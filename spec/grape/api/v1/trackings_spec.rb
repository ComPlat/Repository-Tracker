describe API::V1::Trackings do
  describe "GET /api/v1/trackings/" do
    let(:user) { build(:user) }
    let!(:trackings) { create_list(:tracking, 3, user:) }

    before { get "/api/v1/trackings" }

    it { expect(response).to have_http_status :ok }
    it { expect(response.body).to eq trackings.to_json }
    it { expect(response.content_type).to eq "application/json" }
  end

  describe "GET /api/v1/trackings/:id" do
    let(:user) { build(:user) }

    context "when tracking id exists" do
      let(:tracking1) { create(:tracking, user:) }
      let(:tracking2) { create(:tracking, user:) }
      let(:tracking3) { create(:tracking, user:) }

      before { get "/api/v1/trackings/#{tracking2.id}" }

      it { expect(response).to have_http_status :ok }
      it { expect(response.body).to eq tracking2.to_json }
      it { expect(response.content_type).to eq "application/json" }
    end

    context "when tracking does not exist" do
      let(:expected_json_error) { {error: "Couldn't find Tracking with 'id'=1"}.to_json }

      before { get "/api/v1/trackings/1" }

      it { expect(response).to have_http_status :not_found }
      it { expect(response.body).to eq expected_json_error }
      it { expect(response.content_type).to eq "application/json" }
    end
  end

  describe "POST /api/v1/trackings/" do
    context "when validation errors occurs" do
      let(:user) { create(:user) }
      let(:tracking) { build(:tracking, user:) }
      let(:json_request) {
        {
          from: tracking.from,
          to: tracking.to,
          status: tracking.status,
          metadata: tracking.metadata
        }
      }

      before { post "/api/v1/trackings/", params: json_request }

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(JSON.parse(response.body)).to eq "error" => "Validation failed: User must exist" }
    end

    context "when tracking record is created" do
      let(:user) { create(:user) }
      let(:tracking) { build(:tracking, user:) }
      let(:json_request) {
        {
          from: tracking.from,
          to: tracking.to,
          status: tracking.status,
          metadata: tracking.metadata,
          user_id: user.id
        }
      }
      let(:expected_tracking) { Tracking.first }

      before { post "/api/v1/trackings/", params: json_request }

      it { expect(response).to have_http_status :created }

      it do
        expect(JSON.parse(response.body)).to eq({"id" => expected_tracking.id,
                                                  "from" => tracking.from,
                                                  "to" => tracking.to,
                                                  "status" => tracking.status,
                                                  "metadata" => tracking.metadata,
                                                  "date_time" => expected_tracking.date_time.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
                                                  "updated_at" => expected_tracking.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
                                                  "created_at" => expected_tracking.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
                                                  "user_id" => user.id})
      end
    end
  end
end
