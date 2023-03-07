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

    it { expect(combined_routes.length).to eq 3 }
    it { expect(combined_routes).to include({"swagger_doc" => []}) }

    describe "trackings routes" do
      let(:expected_trackings_routes) do
        # HINT: combined_routes["trackings"].map { |route|  [route.path, route.version] }
        {"trackings" => match_array([
          be_a(Grape::Router::Route).and(have_attributes(path: "/:version/trackings(.json)", version: "v1")),
          be_a(Grape::Router::Route).and(have_attributes(path: "/:version/trackings/:id(.json)", version: "v1")),
          be_a(Grape::Router::Route).and(have_attributes(path: "/:version/trackings(.json)", version: "v1"))
        ])}
      end

      let(:expected_tracking_items_routes) do
        # HINT: combined_routes["tracking_items"].map { |route|  [route.path, route.version] }
        {"tracking_items" => match_array(
          [be_a(Grape::Router::Route).and(have_attributes(path: "/:version/tracking_items(.json)", version: "v1")),
            be_a(Grape::Router::Route).and(have_attributes(path: "/:version/tracking_items/:name(.json)", version: "v1"))]
        )}
      end

      it { expect(combined_routes).to include expected_trackings_routes }
      it { expect(combined_routes).to include expected_tracking_items_routes }
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
    let(:uid) { Doorkeeper::Application.find_by!(name: "React SPA API Client")&.uid }
    let(:password_flow_config) {
      {oAuth2PasswordFlow:
          {description: "Authorization using `OAuth2` password flow. Field `client_secret` **MUST** be empty!
Use the client_id below:
client_id: **#{ENV["DOORKEEPER_CLIENT_ID"]}**",
           flow: "password",
           tokenUrl: "/oauth/token",
           type: "oauth2"}}
    }
    let(:definitions) {
      {postV1Trackings:
          {type: "object", properties:
            {status: {type: "string", description: "Tracking status"},
             metadata: {type: "json", description: "Tracking metadata"},
             tracking_item_name: {type: "string", description: "Tracking unique identifier"},
             tracking_item_owner_name: {type: "string", description: "Tracking item owner name"},
             from_trackable_system_name: {type: "string", description: "Tracking source"},
             to_trackable_system_name: {type: "string", description: "Tracking receiver"}},
           required: %w[status metadata tracking_item_name tracking_item_owner_name from_trackable_system_name to_trackable_system_name],
           description: "Create a tracking"}}
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(parsed_and_symbolized_response_body.keys.size).to eq 10 }
    it { expect(parsed_and_symbolized_response_body[:info]).to eq(title: "Repository-Tracker API", version: "0.1") }
    it { expect(parsed_and_symbolized_response_body[:swagger]).to eq "2.0" }
    it { expect(parsed_and_symbolized_response_body[:produces]).to eq ["application/json"] }
    it { expect(parsed_and_symbolized_response_body[:host]).to eq "#{ENV["APP_HOST"]}:#{ENV["APP_PORT"]}" }
    it { expect(parsed_and_symbolized_response_body[:basePath]).to eq "/api" }

    it { expect(parsed_and_symbolized_response_body[:securityDefinitions]).to eq password_flow_config }

    it { expect(parsed_and_symbolized_response_body[:security]).to eq [{oAuth2PasswordFlow: []}] }

    it {
      expect(parsed_and_symbolized_response_body[:tags]).to eq [{description: "Operations about trackings", name: "trackings"},
        {description: "Operations about tracking_items", name: "tracking_items"}]
    }

    it { expect(parsed_and_symbolized_response_body[:paths].keys.size).to eq 4 }
    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"].keys.size).to eq 2 }
    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"][:get].keys.size).to eq 5 }
    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/tracking_items"].keys.size).to eq 1 }
    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/tracking_items"][:get].keys.size).to eq 5 }

    it {
      expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"][:get]).to eq(description: "Return list of trackings",
        operationId: "getV1Trackings",
        produces: ["application/json"],
        responses: {"200": {description: "Return list of trackings"}},
        tags: ["trackings"])
    }

    it { expect(parsed_and_symbolized_response_body[:paths][:"/v1/trackings"][:post].keys.size).to eq 7 }

    it {
      expect(parsed_and_symbolized_response_body[:paths][:"/v1/tracking_items"][:get]).to eq(description: "Return list of tracking_items",
        operationId: "getV1TrackingItems",
        produces: ["application/json"],
        responses: {"200": {description: "Return list of tracking_items"}},
        tags: ["tracking_items"])
    }

    it { expect(parsed_and_symbolized_response_body[:definitions]).to eq definitions }

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
        [{in: "body", name: "postV1Trackings", required: true, schema: {:$ref => "#/definitions/postV1Trackings"}}]
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
