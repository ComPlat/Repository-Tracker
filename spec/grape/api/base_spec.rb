describe API::Base do
  describe ".new" do
    subject { described_class.new }

    it { is_expected.to be_a Grape::API::Instance }
  end

  describe ".format" do
    subject { described_class.format }

    it { is_expected.to eq :json }
  end

  describe ".content_types" do
    subject { described_class.content_types }

    it { is_expected.to eq({json: "application/json"}) }
  end

  describe ".combined_routes" do
    subject(:combined_routes) { described_class.combined_routes }

    it { expect(combined_routes.length).to eq 2 }
    it { expect(combined_routes).to include({"swagger_doc" => []}) }

    describe "trackings routes" do
      let(:expected_routes) do
        # HINT: combined_routes["trackings"].map { |route|  [route.path, route.version] }
        {"trackings" => [
          be_a(Grape::Router::Route).and(have_attributes(path: "/:version/trackings(.json)", version: "v1")),
          be_a(Grape::Router::Route).and(have_attributes(path: "/:version/trackings/:id(.json)", version: "v1")),
          be_a(Grape::Router::Route).and(have_attributes(path: "/:version/trackings(.json)", version: "v1"))
        ]}
      end

      it { expect(combined_routes).to include expected_routes }
    end
  end

  describe "response.headers" do
    let(:test_api) { Class.new(described_class) }

    before { test_api.get "test" }

    describe "GET /api/v1/test" do
      before { get "/api/v1/test" }

      it { expect(response.headers.length).to eq 7 }
      it { expect(response.headers["Content-Type"]).to eq "application/json" }
      it { expect(response.headers["Access-Control-Allow-Origin"]).to eq "*" }
      it { expect(response.headers["Access-Control-Request-Method"]).to eq "*" }
      it { expect(response.headers["Cache-Control"]).to eq "no-cache" }
      it { expect(response.headers["X-Request-Id"]).to be_a String }
      it { expect(response.headers["X-Runtime"]).to be_a String }
      it { expect(response.headers["Content-Length"]).to be_a String }
    end
  end

  describe "/api/swagger_doc.json" do
    let(:expected_body) do
      {info: {title: "API title", version: "0.0.1"},
       swagger: "2.0",
       produces: ["application/json"],
       host: ENV["HOST_URI"], # HINT: Default value for host URI
       basePath: "/api",
       tags: [{name: "trackings", description: "Operations about trackings"}],
       paths: {"/v1/trackings":
                   {get:
                       {description: "Return list of trackings",
                        produces: ["application/json"],
                        responses: {"200": {description: "Return list of trackings"}},
                        tags: ["trackings"],
                        operationId: "getV1Trackings"},
                    post: {description: "Create a tracking",
                           produces: ["application/json"],
                           consumes: ["application/json"],
                           parameters: [{in: "formData", name: "title", description: "Tracking title", type: "string", required: true},
                             {in: "formData", name: "content",
                              description: "Tracking content", type: "string", required: true}],
                           responses: {"201": {description: "Create a tracking"}},
                           tags: ["trackings"],
                           operationId: "postV1Trackings"}},
               "/v1/trackings/{id}":
                   {get:
                       {description: "Return a tracking",
                        produces: ["application/json"],
                        parameters: [{in: "path",
                                      name: "id",
                                      description: "Tracking ID",
                                      type: "integer",
                                      format: "int32",
                                      required: true}],
                        responses: {"200": {description: "Return a tracking"}},
                        tags: ["trackings"],
                        operationId: "getV1TrackingsId"}}}}
    end

    before { get "/api/swagger_doc.json" }

    it { expect(response).to have_http_status(:ok) }
    it { expect(JSON.parse(response.body).deep_symbolize_keys).to eq expected_body }
  end
end
