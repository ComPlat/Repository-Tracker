describe API::V1::Trackings do
  describe "GET /api/v1/trackings/" do
    let(:expected_json) { [{"tracking1" => "My first tracking"}, {"tracking2" => "My second tracking"}].to_json }

    before { get "/api/v1/trackings" }

    it { expect(response).to have_http_status :ok }
    it { expect(response.content_type).to eq "application/json" }
  end

  describe "GET /api/v1/trackings/:id" do
    let(:expected_json) { {"tracking2" => "My second tracking"}.to_json }

    before { get "/api/v1/trackings/1" }

    it { expect(response).to have_http_status :ok }
    it { expect(response.body).to eq expected_json }
    it { expect(response.content_type).to eq "application/json" }
  end

  describe "POST /api/v1/trackings/" do
    let(:title) { "tracking_new" }
    let(:content) { "My new tracking" }
    let(:post_content) { {title:, content:} }

    before { post "/api/v1/trackings/", params: post_content }

    it { expect(response).to have_http_status :created }
    it { expect(JSON.parse(response.body)).to include(title => content) }
  end
end
