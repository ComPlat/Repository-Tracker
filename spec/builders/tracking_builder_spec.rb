describe TrackingBuilder do
  let(:tracking) { build(:tracking, :with_realistic_attributes, :with_required_dependencies) }
  let(:params) do
    {
      "from" => tracking.from,
      "to" => tracking.to,
      "status" => tracking.status,
      "metadata" => tracking.metadata,
      "user_id" => tracking.user.id
    }
  end

  describe ".new" do
    subject(:new) { described_class.new(params) }

    it { is_expected.to be_a described_class }
  end

  describe "#build" do
    subject(:tracker_builder_build) { described_class.new(params).build }

    it { is_expected.to be_a Tracking }
  end

  describe "#create!" do
    subject(:created_tracking) { described_class.new(params).create! }

    it { expect { created_tracking }.to change(Tracking, :count).from(0).to(1) }
    it { expect(created_tracking.from).to eq params["from"] }
    it { expect(created_tracking.to).to eq params["to"] }
    it { expect(created_tracking.status).to eq params["status"] }
    it { expect(created_tracking.metadata).to eq params["metadata"] }
    it { expect(created_tracking.user_id).to eq params["user_id"] }
  end
end
