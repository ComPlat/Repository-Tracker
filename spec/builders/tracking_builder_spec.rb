describe TrackingBuilder do
  let(:tracking) { build(:tracking, :with_required_attributes, :with_required_dependencies) }
  let(:params) do
    {"status" => tracking.status,
     "metadata" => tracking.metadata,
     "from_trackable_system_name" => tracking.from_trackable_system.name,
     "to_trackable_system_name" => tracking.to_trackable_system.name,
     "tracking_item_name" => tracking.tracking_item.name}
  end

  describe ".new" do
    subject(:new) { described_class.new(params) }

    it { is_expected.to be_a described_class }
  end

  describe "#build" do
    subject(:built_tracking) { described_class.new(params).build }

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

    it { expect { created_tracking }.to change(Tracking, :count).from(0).to(1) }
  end
end
