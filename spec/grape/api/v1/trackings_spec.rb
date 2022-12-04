describe API::V1::Trackings do
  describe "GET /api/v1/trackings/" do
    let!(:trackings) { create_list :tracking, 3, :with_realistic_attributes, :with_required_dependencies }

    before { get "/api/v1/trackings" }

    it { expect(response).to have_http_status :ok }
    it { expect(response.body).to eq trackings.to_json }
    it { expect(response.content_type).to eq "application/json" }
  end

  describe "GET /api/v1/trackings/:id" do
    context "when tracking id exists" do
      let(:trackings) { create_list :tracking, 3, :with_realistic_attributes, :with_required_dependencies }

      before { get "/api/v1/trackings/#{trackings.last.id}" }

      it { expect(response).to have_http_status :ok }
      it { expect(response.body).to eq trackings.last.to_json }
      it { expect(response.content_type).to eq "application/json" }
    end

    context "when tracking does not exist" do
      let(:expected_json_error) { {error: "Couldn't find Tracking with 'id'=0"}.to_json }

      before { get "/api/v1/trackings/0" }

      it { expect(response).to have_http_status :not_found }
      it { expect(response.body).to eq expected_json_error }
      it { expect(response.content_type).to eq "application/json" }
    end
  end

  describe "POST /api/v1/trackings/" do
    context "when validation errors occurs" do
      let(:tracking) { build :tracking, :with_realistic_attributes, :with_required_dependencies }
      let(:tracking_request) { build_request(:tracking_request, :create_invalid) }

      before { post "/api/v1/trackings/", params: tracking_request }

      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to eq "error" => "from is missing" }
    end

    context "when tracking record is created" do
      let(:tracking_request) { build_request(:tracking_request, :create) }
      let(:expected_tracking) { Tracking.first }

      before { post "/api/v1/trackings/", params: tracking_request }

      it { expect(response).to have_http_status :created }

      it do
        expect(JSON.parse(response.body)).to eq({"id" => expected_tracking.id,
                                                  "from" => tracking_request[:from],
                                                  "to" => tracking_request[:to],
                                                  "status" => tracking_request[:status],
                                                  "metadata" => tracking_request[:metadata],
                                                  "date_time" => expected_tracking.date_time.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
                                                  "updated_at" => expected_tracking.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
                                                  "created_at" => expected_tracking.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
                                                  "user_id" => tracking_request[:user_id]})
      end
    end
  end
end
