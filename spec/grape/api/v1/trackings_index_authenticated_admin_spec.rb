describe API::V1::Trackings, ".index_authenticated_admin" do
  describe "GET /api/v1/trackings/:id" do
    # HINT: Admin user is always authorized

    let(:user) { create(:user, :with_required_attributes_as_admin) }
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when trackings exist and user is authorized" do
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }
      let(:trackings) { create_list(:tracking, 2, :with_required_attributes, :with_required_dependencies, tracking_item:) }
      let(:expected_json_array) {
        trackings.map { |tracking|
          {"id" => tracking.id,
           "date_time" => tracking.date_time&.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
           "status" => tracking.status,
           "metadata" => tracking.metadata,
           "tracking_item_name" => tracking.tracking_item&.name,
           "from_trackable_system_name" => tracking.from_trackable_system&.name,
           "to_trackable_system_name" => tracking.to_trackable_system&.name,
           "owner_name" => tracking.tracking_item&.user&.name}
        }
      }

      before do
        trackings
        get "/api/v1/trackings/", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to be_a Array }
      it { expect(response.parsed_body.size).to eq 2 }
      it { expect(response.parsed_body.first).to eq JSON.parse(API::Entities::Tracking.new(trackings.first).to_json) }
      it { expect(response.parsed_body.second).to eq JSON.parse(API::Entities::Tracking.new(trackings.second).to_json) }
      it { expect(response.parsed_body).to eq expected_json_array }
    end

    context "when trackings do NOT exist" do
      before { get "/api/v1/trackings/", params: {access_token: access_token.token} }

      it { expect(response).to have_http_status :ok }
      it { expect(response.parsed_body).to eq [] }
      it { expect(response.content_type).to eq "application/json" }
    end
  end
end
