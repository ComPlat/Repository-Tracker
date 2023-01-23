describe "API::V1" do
  include AuthHelper

  describe "GET /api/v1/:path" do
    context "when path does not exist and not authenticated" do
      before { get "/api/v1/not_existing_path" }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"error":"The access token is invalid"}' }
    end

    context "when path does not exist and authenticated" do
      let(:user) { build(:user, :with_required_attributes_as_user) }
      let(:application) { create(:doorkeeper_application, :with_required_attributes) }

      before {
        register(user.name, user.email, user.password)
        login(user.email, user.password)
        get "/api/v1/not_existing_path", params: {access_token: application.access_tokens.last&.token}
      }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to eq '{"error":"Not found"}' }
    end
  end
end
