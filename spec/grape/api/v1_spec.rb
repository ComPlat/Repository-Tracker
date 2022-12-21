describe "API::V1" do
  describe "GET /api/v1/:path" do
    context "when path does not exist and not authenticated" do
      before { get "/api/v1/not_existing_path" }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"error":"The access token is invalid"}' }
    end

    context "when path does not exist and authenticated" do
      let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies) }

      before { get "/api/v1/not_existing_path", params: {access_token: access_token.token} }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to eq '{"error":"Not found"}' }
    end
  end
end
