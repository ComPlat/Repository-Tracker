describe API::V1::TrackingItems, ".index_authenticated_user" do
  let(:user) { create(:user, :with_required_attributes_as_user) }
  let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

  describe "GET /api/v1/tracking_items/" do
    context "when trackings exist and user is authorized" do
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, user:) }
      let(:expected_json_array) {
        tracking_items.map { |tracking_item|
          {"id" => tracking_item.id,
           "name" => tracking_item.name,
           "owner_name" => tracking_item.user.name,
           "tracking_ids" => tracking_item.trackings.ids}
        }
      }

      before do
        create_list(:tracking, 2, :with_required_attributes, :with_required_dependencies, tracking_item: tracking_items.first)
        create_list(:tracking, 2, :with_required_attributes, :with_required_dependencies, tracking_item: tracking_items.second)

        get "/api/v1/tracking_items", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to be_a Array }
      it { expect(response.parsed_body.size).to eq 2 }
      it { expect(response.parsed_body.first).to eq JSON.parse(API::Entities::TrackingItem.new(tracking_items.first, {tracking_ids: tracking_items.first.tracking_ids}).to_json) }
      it { expect(response.parsed_body.second).to eq JSON.parse(API::Entities::TrackingItem.new(tracking_items.second, {tracking_ids: tracking_items.second.tracking_ids}).to_json) }
      it { expect(response.parsed_body).to eq expected_json_array }
    end

    context "when trackings exist and user is NOT authorized" do
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, user: create(:user, :with_required_attributes_as_user)) }

      before do
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:)
        get "/api/v1/tracking_items/", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq [] }
    end

    context "when trackings do NOT exist" do
      before { get "/api/v1/tracking_items/", params: {access_token: access_token.token} }

      it { expect(response).to have_http_status :ok }
      it { expect(response.parsed_body).to eq [] }
      it { expect(response.content_type).to eq "application/json" }
    end
  end
end
