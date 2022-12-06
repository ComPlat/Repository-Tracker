describe TrackingItem do
  describe "factory" do
    it { expect(build(:tracking_item)).to be_invalid }
    it { expect(build(:tracking_item, :with_required_attributes)).to be_invalid }
    it { expect(build(:tracking_item, :with_required_dependencies)).to be_invalid }
    it { expect(build(:tracking_item, :with_required_attributes, :with_required_dependencies)).to be_valid }
  end

  describe "#id" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
  end

  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_db_column(:name).of_type(:text) }
    it { is_expected.to have_db_index(:name).unique }
  end

  describe "#created_at" do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  end

  describe "#updated_at" do
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe "#user" do
    let(:user) { create :user, :with_required_attributes }

    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to belong_to(:user).inverse_of(:tracking_items) }
    it { expect(create(:tracking_item, :with_required_attributes, user:).user).to eq user }
    it { expect { create :tracking_item, :with_required_attributes }.to raise_error ActiveRecord::RecordInvalid, "Validation failed: User must exist" }
  end
end
