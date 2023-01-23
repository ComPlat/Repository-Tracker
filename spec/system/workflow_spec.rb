RSpec.describe "Workflow" do
  include AuthHelper

  let(:application) { create(:doorkeeper_application, :with_required_attributes) }

  describe "As role :user" do
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
        create(:tracking_request, :create)
        register(user.name, user.email, user.password)
        login(user.email, user.password)
        get "/api/v1/trackings/#{create_entry}", params: {access_token: application.access_tokens.last&.token}
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

        get "/api/v1/trackings/#{create_entry}", params: {access_token: application.access_tokens.last&.token}
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

  describe "As role :admin" do
    let(:admin) { create(:user, :with_required_attributes_as_admin) }

    describe "1. Login" do
      before {
        login(admin.email, admin.password)
      }

      it { expect(response).to have_http_status(:ok) }
    end

    describe "2. Login and empty index" do
      before {
        register(admin.name, admin.email, admin.password)
        login(admin.email, admin.password)
        get "/api/v1/trackings", params: {access_token: application.access_tokens.last&.token}
      }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to eq [] }
    end

    describe "3. Login and create entry" do
      before {
        register(admin.name, admin.email, admin.password)
        login(admin.email, admin.password)
        create_entry
      }

      it { expect(response).to have_http_status(:created) }
    end

    describe "4. Login, create entry and filled index" do
      before {
        register(admin.name, admin.email, admin.password)
        login(admin.email, admin.password)
        create_entry
        get "/api/v1/trackings", params: {access_token: application.access_tokens.last&.token}
      }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body.size).to eq 1 }
    end

    describe "5. Login, create entry and show" do
      before {
        register(admin.name, admin.email, admin.password)
        login(admin.email, admin.password)
        create_entry
        get "/api/v1/trackings/#{create_entry}", params: {access_token: application.access_tokens.last&.token}
      }

      it { expect(response).to have_http_status(:ok) }
    end

    describe "6. Login, and expired token" do
      before {
        register(admin.name, admin.email, admin.password)
        login(admin.email, admin.password)
        at = Doorkeeper::AccessToken.last
        at.expires_in = 0
        at.save!

        get "/api/v1/trackings/#{create_entry}", params: {access_token: application.access_tokens.last&.token}
      }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    describe "7. Login and request new refresh token" do
      before {
        register(admin.name, admin.email, admin.password)
        login(admin.email, admin.password)
        revoke(admin.email, admin.password)
        login(admin.email, admin.password)
        at = Doorkeeper::AccessToken.last
        at.token = refresh_token
        at.save!
      }

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
