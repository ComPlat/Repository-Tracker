describe API::V1::Trackings, ".show_authenticated_user" do
  describe "GET /api/v1/trackings/:id" do
    let(:user) { create(:user, :with_required_attributes_as_user) }
    let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:) }
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when tracking id exists and user is authorized" do
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }
      let(:expected_json_hash) {
        {"id" => trackings.last&.id,
         "date_time" => trackings.last&.date_time&.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
         "status" => trackings.last&.status,
         "metadata" => trackings.last&.metadata,
         "tracking_item_name" => trackings.last&.tracking_item&.name,
         "from_trackable_system_name" => trackings.last&.from_trackable_system&.name,
         "to_trackable_system_name" => trackings.last&.to_trackable_system&.name,
         "owner_name" => trackings.last&.tracking_item&.user&.name}
      }

      before do
        trackings
        get "/api/v1/trackings/#{trackings.last&.id}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq JSON.parse(API::Entities::Tracking.new(trackings.last).to_json) }
      it { expect(response.parsed_body).to eq expected_json_hash }
    end

    context "when tracking id exists and user is NOT authorized" do
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, user: create(:user, :with_required_attributes_as_user)) }

      before do
        trackings
        get "/api/v1/trackings/#{trackings.last&.id}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :not_found }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq({"error" => "Couldn't find Tracking with 'id'=#{trackings.last&.id}"}) }
    end

    context "when tracking id does NOT exist" do
      before { get "/api/v1/trackings/0", params: {access_token: access_token.token} }

      it { expect(response).to have_http_status :not_found }
      it { expect(response.parsed_body).to eq("error" => "Couldn't find Tracking with 'id'=0") }
      it { expect(response.content_type).to eq "application/json" }
    end
  end
end
