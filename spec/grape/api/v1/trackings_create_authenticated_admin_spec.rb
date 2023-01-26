describe API::V1::Trackings, ".create_authenticated_admin" do
  describe "POST /api/v1/trackings/" do
    let(:user) { create(:user, :with_required_attributes_as_admin) }
    let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    context "when validation errors occurs" do
      let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
      let(:tracking_request) { build_request(:tracking_request, :create_invalid) }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token) }

      it { expect(response).to have_http_status :bad_request }
      # HINT: This error message comes from params validation which is done before user authentication.
      it { expect(response.parsed_body).to eq "error" => "status is missing, metadata is missing, tracking_item_name is missing, from_trackable_system_name is missing, to_trackable_system_name is missing" }
    end

    context "when authentication errors occurs, because user is no trackable_system_admin" do
      let(:tracking_request) {
        build_request(:tracking_request, :create, from_trackable_system:
          create(:trackable_system, :with_required_attributes, :with_required_dependencies, user:
            create(:user, :with_required_attributes_as_trackable_system_admin)))
      }

      before { post "/api/v1/trackings/", params: tracking_request.merge(access_token: access_token.token) }

      it { expect(response).to have_http_status :unauthorized }
      it { expect(response.parsed_body).to eq "error" => Authorization::TrackingsPost::MSG_TRACKABLE_SYSTEM_ADMIN }
    end
  end
end
