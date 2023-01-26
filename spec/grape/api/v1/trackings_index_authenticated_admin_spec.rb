describe API::V1::Trackings, ".index_authenticated_admin" do
  # TODO: Implement "GET /api/v1/tracking_items/:name/trackings"

  describe "GET /api/v1/trackings/:id" do
    # HINT: Admin user is always authorized

    let(:user) { create(:user, :with_required_attributes_as_admin) }
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when trackings exist and user is authorized" do
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }
      let(:trackings) { create_list(:tracking, 2, :with_required_attributes, :with_required_dependencies, tracking_item:) }
      let(:expected_json_array) {
        [{"id" => trackings.first&.id,
          "date_time" => trackings.first&.date_time&.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
          "status" => trackings.first&.status,
          "metadata" => trackings.first&.metadata,
          "tracking_item_name" => trackings.first&.tracking_item&.name,
          "from_trackable_system_name" => trackings.first&.from_trackable_system&.name,
          "to_trackable_system_name" => trackings.first&.to_trackable_system&.name,
          "owner_name" => trackings.first&.tracking_item&.user&.name},
          {"id" => trackings.second&.id,
           "date_time" => trackings.second&.date_time&.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
           "status" => trackings.second&.status,
           "metadata" => trackings.second&.metadata,
           "tracking_item_name" => trackings.second&.tracking_item&.name,
           "from_trackable_system_name" => trackings.second&.from_trackable_system&.name,
           "to_trackable_system_name" => trackings.second&.to_trackable_system&.name,
           "owner_name" => trackings.second&.tracking_item&.user&.name}]
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
