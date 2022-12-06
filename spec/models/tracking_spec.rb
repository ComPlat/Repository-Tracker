describe Tracking do
  describe "factory" do
    it { expect(build(:tracking)).to be_invalid }
    it { expect(build(:tracking, :with_required_attributes)).to be_invalid }
    it { expect(build(:tracking, :with_required_dependencies)).to be_invalid }
    it { expect(build(:tracking, :with_required_attributes, :with_required_dependencies)).to be_valid }
  end

  describe "#id" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
  end

  describe "#date_time" do
    it { is_expected.to have_db_column(:date_time).of_type(:datetime) }
    # HINT: Presence not needed, because
    #   # HINT Test before_create hook
    #   subject { tracking.date_time }
    #
    #   let(:tracking) { create(:tracking, user:) }
    #
    #   it { is_expected.to eq tracking.created_at }
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
    it { values.values.map { |value| expect(create(:tracking, :with_required_attributes, status: value).role).to eq value } }
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

  # describe "#user" do
  #   let(:user) { create :user }
  #
  #   it { is_expected.to belong_to(:user).inverse_of(:trackings) }
  #   it { expect(create(:tracking, user:).user).to eq user }
  #   it { expect { create :tracking }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: User must exist" }
  # end
  #
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
