describe Tracking do
  describe "factory" do
    it { expect(build(:tracking)).to be_invalid }
    it { expect(build(:tracking, :with_required_attributes)).to be_invalid }
    it { expect(build(:tracking, :with_required_dependencies)).to be_invalid }
    it { expect(build(:tracking, :with_required_attributes, :with_required_dependencies)).to be_valid }
    it { expect(create(:tracking, :with_required_attributes, :with_required_dependencies)).to be_persisted }
  end

  describe "#id" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
  end

  describe "#date_time" do
    let(:tracking) { create(:tracking, :with_required_attributes, :with_required_dependencies) }

    it { is_expected.to have_db_column(:date_time).of_type(:datetime) }
    it { expect(tracking.date_time).to eq tracking.created_at }
  end

  describe "#status" do
    let(:values) {
      {draft: "draft",
       published: "published",
       submitted: "submitted",
       reviewing: "reviewing",
       pending: "pending",
       accepted: "accepted",
       reviewed: "reviewed",
       rejected: "rejected",
       deleted: "deleted"}
    }

    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to have_db_column(:status).of_type(:enum) }
    it { is_expected.to define_enum_for(:status).with_values(values).backed_by_column_of_type(:enum) }
    it { expect { build(:tracking, status: "invalid_status") }.to raise_error ArgumentError, "'invalid_status' is not a valid status" }
    it { values.values.map { |value| expect(create(:tracking, :with_required_attributes, :with_required_dependencies, status: value).status).to eq value } }
  end

  describe "#metadata" do
    it { is_expected.to have_db_column(:metadata).of_type(:jsonb) }
  end

  describe "#created_at" do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  end

  describe "#updated_at" do
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe "#tracking_item" do
    let(:tracking_item) { create :tracking_item, :with_required_attributes, :with_required_dependencies }

    it { is_expected.to have_db_index(:tracking_item_id) }
    it { is_expected.to have_db_column(:tracking_item_id).of_type(:integer) }
    it { is_expected.to belong_to(:tracking_item).inverse_of(:trackings) }
    it { expect(create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:).tracking_item).to eq tracking_item }

    it {
      expect { create :tracking, :with_required_attributes, :with_required_dependencies, tracking_item: nil }
        .to raise_error ActiveRecord::RecordInvalid, "Validation failed: Tracking item must exist" # TODO: Why Tracking item and not TrackingItem?
    }
  end

  # describe "#draft?" do
  #   context "without set status (use default status 'draft' from database)" do
  #     subject { tracking.draft? }
  #
  #     let(:tracking) { described_class.new(user:) }
  #
  #     before { tracking.save }
  #
  #     it { is_expected.to be true }
  #   end
  # end
end
