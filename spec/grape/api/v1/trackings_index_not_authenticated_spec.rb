describe API::V1::Trackings, ".index_not_authenticated" do
  describe "GET /api/v1/trackings/" do
    before { get "/api/v1/trackings" }

    it { expect(response).to have_http_status :unauthorized }
    it { expect(response.body).to eq '{"error":"The access token is invalid"}' }
    it { expect(response.content_type).to eq "application/json; charset=utf-8" }
  end
end
