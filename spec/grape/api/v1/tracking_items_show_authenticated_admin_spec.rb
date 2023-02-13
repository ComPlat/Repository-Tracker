describe API::V1::TrackingItems, ".show_authenticated_admin" do
  describe "GET /api/v1/tracking_items/:id" do
    # HINT: Admin user is always authorized

    let(:user) { create(:user, :with_required_attributes_as_admin) }
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when tracking item name exists and user is authorized" do
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }
      let(:expected_json_hash) {
        {"id" => tracking_item.id,
         "name" => tracking_item.name,
         "owner_name" => tracking_item.user.name,
         "tracking_ids" => tracking_item.trackings.ids}
      }

      before do
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:)

        get "/api/v1/tracking_items/#{tracking_item.name}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq JSON.parse(API::Entities::TrackingItem.new(tracking_item, {tracking_ids: tracking_item.tracking_ids}).to_json) }
      it { expect(response.parsed_body).to eq expected_json_hash }
    end

    context "when tracking item name does NOT exist" do
      before { get "/api/v1/tracking_items/name", params: {access_token: access_token.token} }

      it { expect(response).to have_http_status :not_found }
      it { expect(response.parsed_body).to eq("error" => "Couldn't find TrackingItem with 'id'=") }
      it { expect(response.content_type).to eq "application/json" }
    end
  end
end
