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

    it {
      values.values.map { |value|
        expect(create(:tracking, :with_required_attributes, :with_required_dependencies, status: value).status)
          .to eq value
      }
    }

    it {
      values.values.map { |value|
        expect(create(:tracking, :with_required_attributes, :with_required_dependencies, status: value).public_send("#{value}?"))
          .to be true
      }
    }
  end

  describe "#metadata" do
    it { is_expected.to validate_presence_of(:metadata) }
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

  describe "#from_trackable_system" do
    let(:from_trackable_system) { create :trackable_system, :with_required_attributes }

    it { is_expected.to have_db_index(:from_trackable_system_id) }
    it { is_expected.to have_db_column(:from_trackable_system_id).of_type(:integer) }
    it { is_expected.to belong_to(:from_trackable_system).class_name("TrackableSystem").inverse_of(:from_trackings) }

    it {
      expect(create(:tracking, :with_required_attributes, :with_required_dependencies, from_trackable_system:).from_trackable_system)
        .to eq from_trackable_system
    }

    it {
      expect { create :tracking, :with_required_attributes, :with_required_dependencies, from_trackable_system: nil }
        .to raise_error ActiveRecord::RecordInvalid, "Validation failed: From trackable system must exist"
    }
  end

  describe "#to_trackable_system" do
    let(:to_trackable_system) { create :trackable_system, :with_required_attributes }

    it { is_expected.to have_db_index(:to_trackable_system_id) }
    it { is_expected.to have_db_column(:to_trackable_system_id).of_type(:integer) }
    it { is_expected.to belong_to(:to_trackable_system).class_name("TrackableSystem").inverse_of(:to_trackings) }

    it {
      expect(create(:tracking, :with_required_attributes, :with_required_dependencies, to_trackable_system:).to_trackable_system)
        .to eq to_trackable_system
    }

    it {
      expect { create :tracking, :with_required_attributes, :with_required_dependencies, to_trackable_system: nil }
        .to raise_error ActiveRecord::RecordInvalid, "Validation failed: To trackable system must exist"
    }
  end
end
