describe TrackingItem do
  describe "factory" do
    it { expect(build(:tracking_item)).to be_invalid }
    it { expect(build(:tracking_item, :with_required_attributes)).to be_invalid }
    it { expect(build(:tracking_item, :with_required_dependencies)).to be_invalid }
    it { expect(build(:tracking_item, :with_required_attributes, :with_required_dependencies)).to be_valid }
    it { expect(create(:tracking_item, :with_required_attributes, :with_required_dependencies)).to be_persisted }
    it { expect(create(:tracking_item, :with_required_attributes, :with_required_dependencies)).to be_valid }
  end

  describe "#id" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
  end

  describe "#name" do
    subject(:tracking_item) { build(:tracking_item, :with_required_attributes, :with_required_dependencies) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
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
    let(:user) { create(:user, :with_required_attributes) }

    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to belong_to(:user).inverse_of(:tracking_items) }
    it { expect(create(:tracking_item, :with_required_attributes, user:).user).to eq user }

    it {
      expect { create(:tracking_item, :with_required_attributes, user: nil) }.to raise_error ActiveRecord::RecordInvalid,
        "Validation failed: User #{described_class::USER_INCLUSION_ERROR_MESSAGE}, User must exist"
    }

    it {
      expect { create(:tracking_item, :with_required_attributes, user: create(:user, :with_required_attributes, role: :admin)) }
        .to raise_error ActiveRecord::RecordInvalid, "Validation failed: User #{described_class::USER_INCLUSION_ERROR_MESSAGE}"
    }
  end

  describe "#trackings" do
    subject(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

    let(:tracking) { create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:) }

    it { is_expected.to have_many(:trackings).inverse_of(:tracking_item) }
    it { expect(tracking_item.trackings).to eq [] }
    it { expect(tracking_item.trackings).to eq [tracking] }
  end
end
