RSpec.describe "WorkflowTrackableSystemAdmin" do
  include AuthHelper

  let(:application) { create(:doorkeeper_application, :with_required_attributes) }
  let(:trackable_system_admin) { create(:user, :with_required_attributes_as_trackable_system_admin) }

  describe "1. Login" do
    before { login(trackable_system_admin.email, trackable_system_admin.password) }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "2. Login and empty index" do
    before {
      register(trackable_system_admin.name, trackable_system_admin.email, trackable_system_admin.password)
      login(trackable_system_admin.email, trackable_system_admin.password)
      get "/api/v1/trackings", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq [] }
  end

  describe "3. Login and create entry" do
    before {
      register(trackable_system_admin.name, trackable_system_admin.email, trackable_system_admin.password)
      login(trackable_system_admin.email, trackable_system_admin.password)
      create_entry
    }

    it { expect(response).to have_http_status(:unauthorized) }
  end

  describe "4. Login, create entry and filled index" do
    before {
      register(trackable_system_admin.name, trackable_system_admin.email, trackable_system_admin.password)
      login(trackable_system_admin.email, trackable_system_admin.password)
      create_entry
      get "/api/v1/trackings", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body.size).to eq 0 }
  end

  describe "5. Login, create entry and show" do
    before {
      register(trackable_system_admin.name, trackable_system_admin.email, trackable_system_admin.password)
      login(trackable_system_admin.email, trackable_system_admin.password)
      create_entry
      get "/api/v1/trackings/#{create_entry}", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "6. Login, and expired token" do
    before {
      register(trackable_system_admin.name, trackable_system_admin.email, trackable_system_admin.password)
      login(trackable_system_admin.email, trackable_system_admin.password)
      at = Doorkeeper::AccessToken.last
      at.expires_in = 0
      at.save!

      get "/api/v1/trackings/#{create_entry}", params: {access_token: application.access_tokens.last&.token}
    }

    it { expect(response).to have_http_status(:unauthorized) }
  end

  describe "7. Login and request new refresh token" do
    before {
      register(trackable_system_admin.name, trackable_system_admin.email, trackable_system_admin.password)
      login(trackable_system_admin.email, trackable_system_admin.password)
      revoke(trackable_system_admin.email, trackable_system_admin.password)
      login(trackable_system_admin.email, trackable_system_admin.password)
      at = Doorkeeper::AccessToken.last
      at.token = refresh_token
      at.save!
    }

    it { expect(response).to have_http_status(:ok) }
  end
end
