describe TrackingBuilder do
  describe ".new" do
    subject(:new) { described_class.new(params) }

    let(:params) { {} }

    it { is_expected.to be_a described_class }
  end

  describe "#build" do
    subject(:built_tracking) { described_class.new(params).build }

    let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
    let(:params) do
      {"status" => tracking.status,
       "metadata" => tracking.metadata,
       "from_trackable_system_name" => tracking.from_trackable_system.name,
       "to_trackable_system_name" => tracking.to_trackable_system.name,
       "tracking_item_name" => tracking.tracking_item.name,
       "tracking_item_owner_email" => tracking.tracking_item.user.email}
    end

    it { is_expected.to be_a Tracking }
    it { expect(built_tracking.id).to be_nil }
    it { expect(built_tracking.date_time).to be_nil }
    it { expect(built_tracking.status).to eq params["status"] }
    it { expect(built_tracking.metadata).to eq params["metadata"] }
    it { expect(built_tracking.tracking_item).to eq TrackingItem.find_by(name: params["tracking_item_name"]) }
    it { expect(built_tracking.from_trackable_system).to eq TrackableSystem.find_by(name: params["from_trackable_system_name"]) }
    it { expect(built_tracking.to_trackable_system).to eq TrackableSystem.find_by(name: params["to_trackable_system_name"]) }
  end

  describe "#create!" do
    subject(:created_tracking) { described_class.new(params).create! }

    let(:expected_tracking) {
      {"id" => created_tracking.id,
       "date_time" => created_tracking.date_time.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
       "status" => created_tracking.status,
       "metadata" => created_tracking.metadata,
       "tracking_item_id" => created_tracking.tracking_item_id,
       "from_trackable_system_id" => created_tracking.from_trackable_system_id,
       "to_trackable_system_id" => created_tracking.to_trackable_system_id,
       "created_at" => created_tracking.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
       "updated_at" => created_tracking.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")}
    }
    let(:expected_tracking_item) {
      {"id" => created_tracking.tracking_item.id,
       "name" => created_tracking.tracking_item.name,
       "user_id" => created_tracking.tracking_item.user_id,
       "created_at" => created_tracking.tracking_item.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
       "updated_at" => created_tracking.tracking_item.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")}
    }

    context "when required dependencies already exist in database" do
      let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
      let(:params) do
        {"status" => tracking.status,
         "metadata" => tracking.metadata,
         "from_trackable_system_name" => tracking.from_trackable_system.name,
         "to_trackable_system_name" => tracking.to_trackable_system.name,
         "tracking_item_owner_email" => tracking.tracking_item.user.email,
         "tracking_item_name" => tracking.tracking_item.name}
      end

      it { expect { created_tracking }.to change(Tracking, :count).from(0).to(1) }
      it { expect { created_tracking }.to change(TrackingItem, :count).from(0).to(1) }
      it { expect(created_tracking.as_json).to eq expected_tracking }
      it { expect(created_tracking.tracking_item.as_json).to eq expected_tracking_item }
    end

    context "when trackable systems exist, but tracking item do NOT exist in database" do
      let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item: nil) }
      let(:params) do
        {"status" => tracking.status,
         "metadata" => tracking.metadata,
         "from_trackable_system_name" => tracking.from_trackable_system.name,
         "to_trackable_system_name" => tracking.to_trackable_system.name,
         "tracking_item_owner_email" => "user@example.com",
         "tracking_item_name" => "name1"}
      end

      it { expect { created_tracking }.to change(Tracking, :count).from(0).to(1) }
      it { expect { created_tracking }.to change(TrackingItem, :count).from(0).to(1) }
      it { expect(created_tracking.as_json).to eq expected_tracking }
      it { expect(created_tracking.tracking_item.as_json).to eq expected_tracking_item }
    end
  end
end
