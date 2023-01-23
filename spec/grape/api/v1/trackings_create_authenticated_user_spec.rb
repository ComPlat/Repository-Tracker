describe API::V1::Trackings, ".create_authenticated_user" do
  # TODO: Missing specs for "trackings exist + authorized", "trackings exist + NOT authorized", "trackings does NOT exist + authorized(?!)"

  describe "POST /api/v1/trackings/" do
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when validation errors occurs" do
      let(:user) { create(:user, :with_required_attributes) }
      let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
      let(:tracking_request) { build_request(:tracking_request, :create_invalid) }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token) }

      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to eq "error" => "status is missing, metadata is missing, tracking_item_name is missing, from_trackable_system_name is missing, to_trackable_system_name is missing" }
    end

    context "when authentication errors occurs, because user is no trackable_system_admin" do
      let(:user) { create(:user, :with_required_attributes, role: :user) }
      let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
      let(:tracking_request) {
        build_request(:tracking_request, :create, from_trackable_system_name:
          create(:trackable_system, :with_required_attributes, :with_required_dependencies, user:
            create(:user, :with_required_attributes, role: :trackable_system_admin)).name)
      }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token) }

      it { expect(response).to have_http_status :unauthorized }
      it { expect(JSON.parse(response.body)).to eq "error" => Authorization::TrackingsPost::MSG_TRACKABLE_SYSTEM_ADMIN }
    end

    context "when authentication errors occurs, because user is a trackable_system_admin but not its owner" do
      let(:user) { create(:user, :with_required_attributes, role: :trackable_system_admin) }
      let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
      let(:tracking_request) {
        build_request(:tracking_request, :create, from_trackable_system_name:
          create(:trackable_system, :with_required_attributes, :with_required_dependencies).name)
      }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token) }

      it { expect(response).to have_http_status :unauthorized }
      it { expect(JSON.parse(response.body)).to eq "error" => Authorization::TrackingsPost::MSG_TRACKABLE_SYSTEM_OWNER }
    end

    context "when tracking record is created" do
      let(:user) { create(:user, :with_required_attributes, role: :trackable_system_admin) }
      let(:tracking_request) {
        build_request(:tracking_request, :create, from_trackable_system_name:
          create(:trackable_system, :with_required_attributes, :with_required_dependencies, user:).name)
      }
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

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token) }

      it { expect(response).to have_http_status :created }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(JSON.parse(response.body)).to eq JSON.parse(API::Entities::Tracking.new(expected_tracking).to_json) }
      it { expect(JSON.parse(response.body)).to eq expected_json_hash }
    end
  end
end
