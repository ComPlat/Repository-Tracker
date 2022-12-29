describe User do
  describe "factory" do
    it { expect(build(:user)).to be_invalid }
    it { expect(build(:user, :with_required_attributes)).to be_valid }
    it { expect(create(:user, :with_required_attributes)).to be_persisted }
    it { expect(create(:user, :with_required_attributes)).to be_valid }
  end

  describe "#id" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
  end

  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_db_column(:name).of_type(:text) }
  end

  describe "#role" do
    let(:values) { {user: "user", super: "super", admin: "admin"} }

    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to have_db_column(:role).of_type(:enum) }
    it { is_expected.to define_enum_for(:role).with_values(values).backed_by_column_of_type(:enum) }
    it { expect { build(:user, role: "invalid_role") }.to raise_error ArgumentError, "'invalid_role' is not a valid role" }
    it { values.values.map { |value| expect(create(:user, :with_required_attributes, role: value).role).to eq value } }
  end

  describe "#created_at" do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  end

  describe "#updated_at" do
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe "#email" do
    it { is_expected.to have_db_column(:email).of_type(:text) }
  end

  describe "#encrypted_password" do
    it { is_expected.to have_db_column(:encrypted_password).of_type(:text) }
  end

  describe "#reset_password_token" do
    it { is_expected.to have_db_column(:reset_password_token).of_type(:text) }
  end

  describe "#reset_password_sent_at" do
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
  end

  describe "#remember_created_at" do
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
  end

  describe "#tracking_items" do
    subject(:user) { create(:user, :with_required_attributes) }

    let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }

    it { is_expected.to have_many(:tracking_items).inverse_of(:user) }
    it { expect(user.tracking_items).to eq [] }
    it { expect(user.tracking_items).to eq [tracking_item] }
  end

  describe "#access_tokens" do
    subject(:user) { create(:user, :with_required_attributes) }

    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    it { is_expected.to have_many(:access_tokens) }
    it { expect(user.access_tokens).to eq [] }
    it { expect(user.access_tokens).to eq [access_token] }
  end
end
