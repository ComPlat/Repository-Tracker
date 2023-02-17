describe API::V1::Trackings, ".show_not_authenticated" do
  describe "GET /api/v1/trackings/:id" do
    before { get "/api/v1/trackings/0" }

    it { expect(response).to have_http_status :unauthorized }
    it { expect(response.body).to eq '{"error":"The access token is invalid"}' }
    it { expect(response.content_type).to eq "application/json; charset=utf-8" }
  end
end
