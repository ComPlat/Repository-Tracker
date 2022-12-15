describe API::V1::Trackings do
  # TODO: Implement "GET /api/v1/tracking_items/:name/trackings"
  describe "GET /api/v1/trackings/" do
    let!(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }

    before { get "/api/v1/trackings" }

    it { expect(response).to have_http_status :ok }
    it { expect(response.body).to eq trackings.to_json }
    it { expect(response.content_type).to eq "application/json" }
  end

  describe "GET /api/v1/trackings/:id" do
    context "when tracking id exists" do
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }
      let(:expected_tracking) { trackings.last }
      let(:expected_json_hash) {
        {"id" => expected_tracking.id,
         "date_time" => expected_tracking.date_time.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
         "status" => expected_tracking.status,
         "metadata" => expected_tracking.metadata,
         "tracking_item_name" => expected_tracking.tracking_item.name,
         "from_trackable_system_name" => expected_tracking.from_trackable_system.name,
         "to_trackable_system_name" => expected_tracking.to_trackable_system.name,
         "owner_name" => expected_tracking.tracking_item.user.name}
      }

      before { get "/api/v1/trackings/#{expected_tracking.id}" }

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(JSON.parse(response.body)).to eq JSON.parse(API::Entities::Tracking.new(expected_tracking).to_json) }
      it { expect(JSON.parse(response.body)).to eq expected_json_hash }
    end

    context "when tracking does not exist" do
      let(:expected_json_error) { {error: "Couldn't find Tracking with 'id'=0"}.to_json }

      before { get "/api/v1/trackings/0" }

      it { expect(response).to have_http_status :not_found }
      it { expect(response.body).to eq expected_json_error }
      it { expect(response.content_type).to eq "application/json" }
    end
  end

  describe "POST /api/v1/trackings/" do
    context "when validation errors occurs" do
      let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
      let(:tracking_request) { build_request(:tracking_request, :create_invalid) }

      before { post "/api/v1/trackings/", params: tracking_request }

      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to eq "error" => "status is missing, metadata is missing, tracking_item_name is missing, from_trackable_system_name is missing, to_trackable_system_name is missing" }
    end

    context "when tracking record is created" do
      let(:tracking_request) { build_request(:tracking_request, :create) }
      let(:expected_tracking) { Tracking.first }
      let(:expected_json_hash) {
        {"id" => expected_tracking.id,
         "date_time" => expected_tracking.date_time.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
         "status" => tracking_request[:status],
         "metadata" => tracking_request[:metadata],
         "tracking_item_name" => tracking_request[:tracking_item_name],
         "from_trackable_system_name" => tracking_request[:from_trackable_system_name],
         "to_trackable_system_name" => tracking_request[:to_trackable_system_name],
         "owner_name" => expected_tracking.tracking_item.user.name}
      }

      before { post "/api/v1/trackings/", params: tracking_request }

      it { expect(response).to have_http_status :created }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(JSON.parse(response.body)).to eq JSON.parse(API::Entities::Tracking.new(expected_tracking).to_json) }
      it { expect(JSON.parse(response.body)).to eq expected_json_hash }
    end
  end
end
