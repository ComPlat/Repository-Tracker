describe API::V1::Trackings, ".show_authenticated_trackable_system_admin" do
  describe "GET /api/v1/trackings/:id" do
    let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
    let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }
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
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when tracking id exists, user is authorized but tracking do NOT belong to trackable system" do
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:) }

      before do
        trackings
        get "/api/v1/trackings/#{expected_tracking.id}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :not_found }
      it { expect(response.parsed_body).to eq({"error" => "Couldn't find Tracking with 'id'=#{expected_tracking.id}"}) }
    end

    context "when tracking id exists, user is authorized but trackings do belong to from_trackable_system" do
      let(:trackings) {
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:,
          from_trackable_system:
            create(:trackable_system, :with_required_attributes, :with_required_dependencies, name: "chemotion_electronic_laboratory_notebook", user:))
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

    context "when tracking id exists, user is authorized but trackings do belong to to_trackable_system" do
      let(:trackings) {
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:, to_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies,
          name: "chemotion_electronic_laboratory_notebook", user:))
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

    context "when tracking id exists and user is NOT authorized" do
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:) }

      before do
        trackings
        get "/api/v1/trackings/#{expected_tracking.id}", params: {access_token: access_token.token}
      end

      it { expect(response).to have_http_status :not_found }
      it { expect(response.content_type).to eq "application/json" }
      it { expect(response.parsed_body).to eq({"error" => "Couldn't find Tracking with 'id'=#{expected_tracking.id}"}) }
    end

    context "when tracking id does NOT exist" do
      before { get "/api/v1/trackings/0", params: {access_token: access_token.token} }

      it { expect(response).to have_http_status :not_found }
      it { expect(response.parsed_body).to eq("error" => "Couldn't find Tracking with 'id'=0") }
      it { expect(response.content_type).to eq "application/json" }
    end
  end
end
