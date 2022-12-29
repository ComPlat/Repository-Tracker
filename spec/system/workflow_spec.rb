RSpec.describe "Workflow" do
  include AuthHelper

  let(:application) { create(:doorkeeper_application, :with_required_attributes) }

  describe "1. Register" do
    before { register }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "2. Register, and Login" do
    before {
      register
      login
    }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "3. Register, login and empty index" do
    before {
      register
      login
      get "/api/v1/trackings", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq [] }
  end

  describe "4. Register, login and create entry" do
    before {
      register
      login
      create_entry
    }

    it { expect(response).to have_http_status(:created) }
  end

  describe "5. Register, login, create entry and filled index" do
    before {
      register
      login
      create_entry
      get "/api/v1/trackings", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body.size).to eq 1 }
  end

  describe "6. Register, login, create entry and show" do
    before {
      register
      login
      create_entry
      get "/api/v1/trackings/#{create_entry}", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "7. Register, login, and expired token" do
    before {
      register
      login
      at = Doorkeeper::AccessToken.last
      at.expires_in = 0
      at.save!

      get "/api/v1/trackings/#{create_entry}", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:unauthorized) }
  end

  describe "8. Register, login and request new refresh token" do
    before {
      register
      login
      revoke
      login
      at = Doorkeeper::AccessToken.last
      at.token = refresh_token
      at.save!
    }

    it { expect(response).to have_http_status(:ok) }
  end
end
