describe API::V1::Trackings, ".show_authenticated_super" do
  describe "GET /api/v1/trackings/:id" do
    # HINT: Super user is always authorized

    let(:user) { create(:user, :with_required_attributes_as_super) }
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when tracking id exists and user is authorized" do
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:) }
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

      before do
        trackings
        get "/api/v1/trackings/#{expected_tracking.id}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq JSON.parse(API::Entities::Tracking.new(expected_tracking).to_json) }
      it { expect(response.parsed_body).to eq expected_json_hash }
    end

    context "when tracking id does NOT exist" do
      before { get "/api/v1/trackings/0", params: {access_token: access_token.token} }

      it { expect(response).to have_http_status :not_found }
      it { expect(response.parsed_body).to eq("error" => "Couldn't find Tracking with 'id'=0") }
      it { expect(response.content_type).to eq "application/json" }
    end
  end
end