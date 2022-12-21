RSpec.describe "Workflow" do
  # TODO: Move this initial app setup. Seed?!
  let(:application) { create(:doorkeeper_application, :with_required_attributes, :with_required_dependencies) }

  def register
    # TODO: Move this to factory.
    @register ||= -> {
      post "/users",
        headers: {Accept: "application/json", "Content-Type": "application/json"},
        params: {user:
                   {name: "name", role: "user", email: "tobias.vetter@cleanercode.de", password: "verysecure", client_id: application.uid}}, as: :json
      JSON.parse(response.body)["access_token"]
    }.call
  end

  def login
    post "/oauth/token",
      headers: {Accept: "application/json", "Content-Type": "application/json"},
      params: {
        grant_type: "password",
        email: "tobias.vetter@cleanercode.de",
        password: "verysecure"
        # redirect_uri: "https://www.example.com/",
        # response_type: "token",
        # scope: "",
        # # email: "tobias.vetter@cleanercode.de",
        # # password: "verysecure",
        # # grant_type: "password",
        # client_id: application.uid # TODO: How to communicate to front end?!
        # # client_secret: application.secret # FIXME: How is front end supposed to do this?!
      }, as: :json
  end

  def create_entry
    @create_entry ||= -> {
      post "/api/v1/trackings/", params: build_request(:tracking_request, :create).merge(access_token: register)

      JSON.parse(response.body)["id"]
    }.call
  end

  describe "1. Register" do
    before { register }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "2. Empty Index" do
    before { get "/api/v1/trackings", params: {access_token: register} }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq [] }
  end

  describe "3. Create" do
    before { create_entry }

    it { expect(response).to have_http_status(:created) }
  end

  describe "4. Filled Index" do
    before {
      create_entry
      get "/api/v1/trackings", params: {access_token: register}
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body.size).to eq 1 }
  end

  describe "5. Show" do
    before {
      get "/api/v1/trackings/#{create_entry}", params: {access_token: register}
    }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "6. Expired Token" do
    before {
      register
      at = Doorkeeper::AccessToken.last
      at.expires_in = 0
      at.save!

      get "/api/v1/trackings/#{create_entry}", params: {access_token: register}
    }

    it { expect(response).to have_http_status(:unauthorized) }
  end

  describe "7. Refresh Token works" do
    before {
      register
      at = Doorkeeper::AccessToken.last
      at.expires_in = 0
      at.save!

      post "/oauth/token",
        headers: {Accept: "application/json", "Content-Type": "application/json"},
        params: {
          grant_type: "password",
          email: "tobias.vetter@cleanercode.de",
          password: "verysecure"
        }, as: :json
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq({}) }
  end
end
