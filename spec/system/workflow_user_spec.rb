RSpec.describe "WorkflowUser" do
  include AuthHelper

  let(:application) { Doorkeeper::Application.find_by!(name: "React SPA API Client") }
  let(:user) { build(:user, :with_required_attributes_as_user) }

  describe "1. Register" do
    before { register(user.name, user.email, user.password) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "2. Register and confirm email" do
    before {
      register(user.name, user.email, user.password)
      confirm_email(user.email)
    }

    it { expect(response).to have_http_status(:found) }
    it { expect(response.body).to include "/confirmation_successful" }
  end

  describe "3. Register, confirm email and login" do
    before {
      register(user.name, user.email, user.password)
      confirm_email(user.email)
      login(user.email, user.password)
    }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "4. Register, confirm email, login and empty index" do
    before {
      register(user.name, user.email, user.password)
      confirm_email(user.email)
      login(user.email, user.password)
      get "/api/v1/trackings", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq [] }
  end

  describe "5. Register, confirm email, login, create entry and show" do
    before {
      register(user.name, user.email, user.password)
      confirm_email(user.email)
      login(user.email, user.password)
      create_entry(user.name)
      get "/api/v1/trackings/#{create_entry(user.name)}", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "6. Register, confirm email, login, and expired token" do
    before {
      register(user.name, user.email, user.password)
      confirm_email(user.email)
      login(user.email, user.password)
      at = Doorkeeper::AccessToken.last
      at.expires_in = 0
      at.save!

      get "/api/v1/trackings/#{create_entry(user.name)}", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:unauthorized) }
  end

  describe "7. Register, confirm email, login and request new refresh token" do
    before {
      register(user.name, user.email, user.password)
      confirm_email(user.email)
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
