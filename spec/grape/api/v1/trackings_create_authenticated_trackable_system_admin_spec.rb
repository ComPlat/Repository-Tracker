describe API::V1::Trackings, ".create_authenticated_trackable_system_admin" do
  describe "POST /api/v1/trackings/" do
    let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
    let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when validation errors occurs" do
      let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
      let(:tracking_request) { build_request(:tracking_request, :create_invalid) }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token) }

      it { expect(response).to have_http_status :bad_request }
      # HINT: This error message comes from params validation which is done before user authentication.
      it { expect(response.parsed_body).to eq "error" => "status is missing, metadata is missing, tracking_item_name is missing, tracking_item_owner_name is missing, from_trackable_system_name is missing, to_trackable_system_name is missing" }
    end

    context "when authentication errors occurs, because user is a trackable_system_admin but not its owner" do
      let(:tracking_request) {
        build_request(:tracking_request, :create, from_trackable_system:
          create(:trackable_system, :with_required_attributes, :with_required_dependencies))
      }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token, tracking_item_owner_name: user.name) }

      it { expect(response).to have_http_status :unauthorized }
      it { expect(response.parsed_body).to eq "error" => Authorization::TrackingsPost::MSG_TRACKABLE_SYSTEM_OWNER }
    end

    context "when authorized and tracking_request is valid" do
      let(:tracking_request) {
        build_request(:tracking_request, :create, from_trackable_system_name:
          create(:trackable_system, :with_required_attributes, user:).name)
      }

      let(:expected_json_hash) {
        tracking = Tracking.first

        {"id" => tracking&.id,
         "date_time" => tracking&.date_time&.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
         "status" => tracking_request[:status],
         "metadata" => tracking_request[:metadata],
         "tracking_item_name" => tracking_request[:tracking_item_name],
         "from_trackable_system_name" => tracking_request[:from_trackable_system_name],
         "to_trackable_system_name" => tracking_request[:to_trackable_system_name],
         "owner_name" => tracking&.tracking_item&.user&.name}
      }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token, tracking_item_owner_name: "user1", tracking_item_owner_email: "user1@example.com") }

      it { expect(response).to have_http_status :created }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq JSON.parse(API::Entities::Tracking.new(Tracking.first).to_json) }
      it { expect(response.parsed_body).to eq expected_json_hash }
    end

    context "when authorized, tracking_request is valid, but tracking_item do NOT exist yet" do
      let(:tracking_request) {
        build_request(:tracking_request, :create_without_tracking_item, from_trackable_system_name:
          create(:trackable_system, :with_required_attributes, user:).name)
      }

      let(:expected_json_hash) {
        tracking = Tracking.first
        tracking_item = TrackingItem.first

        {"id" => tracking.id,
         "date_time" => tracking.date_time&.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
         "status" => tracking_request[:status],
         "metadata" => tracking_request[:metadata],
         "tracking_item_name" => tracking_item.name,
         "from_trackable_system_name" => tracking_request[:from_trackable_system_name],
         "to_trackable_system_name" => tracking_request[:to_trackable_system_name],
         "owner_name" => tracking.tracking_item&.user&.name}
      }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token, tracking_item_owner_name: "user1", tracking_item_owner_email: "user1@example.com", tracking_item_name: "name1") }

      it { expect(response).to have_http_status :created }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq expected_json_hash }
    end
  end
end
