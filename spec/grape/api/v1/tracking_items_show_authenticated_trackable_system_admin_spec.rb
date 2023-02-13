describe API::V1::TrackingItems, ".show_authenticated_trackable_system_admin" do
  describe "GET /api/v1/tracking_items/:name" do
    let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
    let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }
    let(:expected_json_hash) {
      {"id" => tracking_item.id,
       "name" => tracking_item.name,
       "owner_name" => tracking_item.user.name,
       "tracking_ids" => tracking_item.trackings.ids}
    }
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when tracking id exists, user is authorized but tracking do NOT belong to trackable system" do
      before do
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:)

        get "/api/v1/tracking_items/#{tracking_item.name}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :not_found }
      it { expect(response.parsed_body).to eq({"error" => "Couldn't find TrackingItem with 'id'="}) }
    end

    context "when tracking id exists, user is authorized but trackings do belong to from_trackable_system" do
      before do
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:,
          from_trackable_system:
            create(:trackable_system, :with_required_attributes, :with_required_dependencies, name: "chemotion_electronic_laboratory_notebook", user:))

        get "/api/v1/tracking_items/#{tracking_item.name}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq JSON.parse(API::Entities::TrackingItem.new(tracking_item, {tracking_ids: tracking_item.tracking_ids}).to_json) }
      it { expect(response.parsed_body).to eq expected_json_hash }
    end

    context "when tracking id exists, user is authorized but trackings do belong to to_trackable_system" do
      let(:trackings) {
      }

      before do
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:, to_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies, name: "chemotion_electronic_laboratory_notebook", user:))

        get "/api/v1/tracking_items/#{tracking_item.name}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq JSON.parse(API::Entities::TrackingItem.new(tracking_item, {tracking_ids: tracking_item.tracking_ids}).to_json) }
      it { expect(response.parsed_body).to eq expected_json_hash }
    end

    context "when tracking id exists and user is NOT authorized" do
      before do
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:)

        get "/api/v1/tracking_items/#{tracking_item.name}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :not_found }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq({"error" => "Couldn't find TrackingItem with 'id'="}) }
    end

    context "when tracking id does NOT exist" do
      before { get "/api/v1/tracking_items/0", params: {access_token: access_token.token} }

      it { expect(response).to have_http_status :not_found }
      it { expect(response.parsed_body).to eq("error" => "Couldn't find TrackingItem with 'id'=") }
      it { expect(response.content_type).to eq "application/json" }
    end
  end
end
