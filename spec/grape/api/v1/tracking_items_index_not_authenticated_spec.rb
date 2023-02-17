describe API::V1::TrackingItems, ".index_not_authenticated" do
  describe "GET /api/v1/tracking_items" do
    before { get "/api/v1/tracking_items" }

    it { expect(response).to have_http_status :unauthorized }
    it { expect(response.body).to eq '{"error":"The access token is invalid"}' }
    it { expect(response.content_type).to eq "application/json; charset=utf-8" }
  end
end
