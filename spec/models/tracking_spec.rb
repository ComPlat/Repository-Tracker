describe Tracking do
  let(:user) { build :user }

  describe "columns" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:from).of_type(:text) }
    it { is_expected.to have_db_column(:date_time).of_type(:datetime) }
    it { is_expected.to have_db_column(:status).of_type(:enum) }
    it { is_expected.to have_db_column(:metadata).of_type(:jsonb) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_index(:user_id) }
  end

  describe "factories" do
    context "with traits :with_realistic_attributes, :with_required_dependencies" do
      subject(:factory) { build :tracking, :with_realistic_attributes, :with_required_dependencies }

      it { is_expected.to be_valid }
      it { expect(factory.save).to be true }
    end
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

    it { is_expected.to define_enum_for(:status).with_values(values).backed_by_column_of_type(:enum) }

    it {
      expect { build(:tracking, status: "invalid_status") }
        .to raise_error ArgumentError, "'invalid_status' is not a valid status"
    }

    it { values.values.map { |value| expect(create(:tracking, :with_required_dependencies, status: value).status).to eq value } }
  end

  describe "#draft?" do
    context "without set status (use default status 'draft' from database)" do
      subject { tracking.draft? }

      let(:tracking) { described_class.new(user:) }

      before { tracking.save }

      it { is_expected.to be true }
    end
  end

  describe "#date_time" do
    # HINT Test before_create hook
    subject { tracking.date_time }

    let(:tracking) { create(:tracking, user:) }

    it { is_expected.to eq tracking.created_at }
  end
end
