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

      it { expect(response.headers.length).to eq 9 }
      it { expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8" }
      it { expect(response.headers["Access-Control-Allow-Origin"]).to eq "*" }
      it { expect(response.headers["Access-Control-Request-Method"]).to eq "*" }
      it { expect(response.headers["Cache-Control"]).to eq "no-store" } # HINT: Because authentication.
      it { expect(response.headers["X-Request-Id"]).to be_a String }
      it { expect(response.headers["X-Runtime"]).to be_a String }
      it { expect(response.headers["Content-Length"]).to be_a String }
      it { expect(response.headers["Pragma"]).to eq "no-cache" }
      it { expect(response.headers["WWW-Authenticate"]).to eq 'Bearer realm="Doorkeeper", error="invalid_token", error_description="The access token is invalid"' }
    end
  end

  describe "/api/swagger_doc.json" do
    before { get "/api/swagger_doc.json" }

    let(:parsed_and_symbolized_response_body) { response.parsed_body.deep_symbolize_keys }

    it { expect(response).to have_http_status(:ok) }
    it { expect(parsed_and_symbolized_response_body.keys.size).to eq 7 }
    it { expect(parsed_and_symbolized_response_body[:info]).to eq(title: "API title", version: "0.0.1") }
    it { expect(parsed_and_symbolized_response_body[:swagger]).to eq "2.0" }
    it { expect(parsed_and_symbolized_response_body[:produces]).to eq ["application/json"] }
    it { expect(parsed_and_symbolized_response_body[:host]).to eq "#{ENV["APP_HOST"]}:#{ENV["APP_PORT"]}" }
    it { expect(parsed_and_symbolized_response_body[:basePath]).to eq "/api" }
    it { expect(parsed_and_symbolized_response_body[:tags]).to eq [{description: "Operations about trackings", name: "trackings"}] }
    it { expect(parsed_and_symbolized_response_body[:paths].keys.size).to eq 2 }
    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"].keys.size).to eq 2 }
    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"][:get].keys.size).to eq 5 }

    it {
      expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"][:get]).to eq(description: "Return list of trackings",
        operationId: "getV1Trackings",
        produces: ["application/json"],
        responses: {"200": {description: "Return list of trackings"}},
        tags: ["trackings"])
    }

    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"][:post].keys.size).to eq 7 }

    describe ":paths, [:''/v1/trackings'], :post" do
      let(:expected_result) {
        {consumes: ["application/json"],
         description: "Create a tracking",
         operationId: "postV1Trackings",
         parameters: be_a(Array),
         produces: ["application/json"],
         responses: {"201": {description: "Create a tracking"}},
         tags: ["trackings"]}
      }

      it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"][:post]).to match expected_result }
    end

    describe ":paths, [:'/v1/trackings'], :post, :parameters" do
      let(:expected_result) {
        [{description: "Tracking status", in: "formData", name: "status", required: true, type: "string"},
          {description: "Tracking metadata", in: "formData", name: "metadata", required: true, type: "json"},
          {description: "Tracking unique identifier", in: "formData", name: "tracking_item_name", required: true, type: "string"},
          {description: "Tracking item owner name", in: "formData", name: "tracking_item_owner_name", required: true, type: "string"},
          {description: "Tracking source", in: "formData", name: "from_trackable_system_name", required: true, type: "string"},
          {description: "Tracking receiver", in: "formData", name: "to_trackable_system_name", required: true, type: "string"}]
      }

      it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"][:post][:parameters]).to eq expected_result }
    end

    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings/{id}"].keys.size).to eq 1 }
    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings/{id}"][:get].keys.size).to eq 6 }

    describe ":paths, [:'/v1/trackings/{id}'], :get" do
      let(:expected_result) {
        {description: "Return a tracking",
         operationId: "getV1TrackingsId",
         parameters: [{description: "Tracking ID", format: "int32", in: "path", name: "id", required: true, type: "integer"}],
         produces: ["application/json"],
         responses: {"200": {description: "Return a tracking"}},
         tags: ["trackings"]}
      }

      it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings/{id}"][:get]).to eq expected_result }
    end
  end
end
