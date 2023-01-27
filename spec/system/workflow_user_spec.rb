RSpec.describe "WorkflowUser" do
  include AuthHelper

  let(:application) { create(:doorkeeper_application, :with_required_attributes) }
  let(:user) { build(:user, :with_required_attributes_as_user) }

  describe "1. Register" do
    before { register(user.name, user.email, user.password) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "2. Register, and Login" do
    before {
      register(user.name, user.email, user.password)
      login(user.email, user.password)
    }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "3. Register, login and empty index" do
    before {
      register(user.name, user.email, user.password)
      login(user.email, user.password)
      get "/api/v1/trackings", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq [] }
  end

  describe "4. Register, login, create entry and show" do
    before {
      register(user.name, user.email, user.password)
      login(user.email, user.password)
      create_entry(user.name)
      get "/api/v1/trackings/#{create_entry(user.name)}", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "5. Register, login, and expired token" do
    before {
      register(user.name, user.email, user.password)
      login(user.email, user.password)
      at = Doorkeeper::AccessToken.last
      at.expires_in = 0
      at.save!

      get "/api/v1/trackings/#{create_entry(user.name)}", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:unauthorized) }
  end

  describe "6. Register, login and request new refresh token" do
    before {
      register(user.name, user.email, user.password)
      login(user.email, user.password)
      revoke(user.email, user.password)
      login(user.email, user.password)
      at = Doorkeeper::AccessToken.last
      at.token = refresh_token
      at.save!
    }

    it { expect(response).to have_http_status(:ok) }
  end
end
