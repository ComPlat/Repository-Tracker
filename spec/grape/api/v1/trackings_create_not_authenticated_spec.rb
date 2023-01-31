describe API::V1::Trackings, ".create_not_authenticated" do
  describe "POST /api/v1/trackings/" do
    before { post "/api/v1/trackings/" }

    it { expect(response).to have_http_status :unauthorized }
    it { expect(response.body).to eq '{"error":"The access token is invalid"}' }
    it { expect(response.content_type).to eq "application/json; charset=utf-8" }
  end
end
