describe API::V1::TrackingItems, ".show_not_authenticated" do
  describe "GET /api/v1/tracking_items/:name" do
    before { get "/api/v1/trackings/name" }

    it { expect(response).to have_http_status :unauthorized }
    it { expect(response.body).to eq '{"error":"The access token is invalid"}' }
    it { expect(response.content_type).to eq "application/json; charset=utf-8" }
  end
end
