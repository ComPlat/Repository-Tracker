describe User do
  describe "factory" do
    it { expect(build(:user)).to be_invalid }
    it { expect(build(:user, :with_required_attributes_as_user)).to be_valid }
    it { expect(create(:user, :with_required_attributes_as_user)).to be_persisted }
    it { expect(create(:user, :with_required_attributes_as_user)).to be_valid }
  end

  describe "#id" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
  end

  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_db_column(:name).of_type(:text) }
  end

  describe "#role" do
    let(:values) { {user: "user", super: "super", admin: "admin", trackable_system_admin: "trackable_system_admin"} }

    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to have_db_column(:role).of_type(:enum) }
    it { is_expected.to define_enum_for(:role).with_values(values).backed_by_column_of_type(:enum) }
    it { expect { build(:user, role: "invalid_role") }.to raise_error ArgumentError, "'invalid_role' is not a valid role" }
    it { values.values.map { |value| expect(create(:user, :with_required_attributes_as_user, role: value).role).to eq value } }
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

  describe "#confirmation_token" do
    it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }
  end

  describe "#confirmed_at" do
    it { is_expected.to have_db_column(:confirmed_at).of_type(:datetime) }
  end

  describe "#confirmation_sent_at" do
    it { is_expected.to have_db_column(:confirmation_sent_at).of_type(:datetime) }
  end

  describe "#unconfirmed_email" do
    it { is_expected.to have_db_column(:unconfirmed_email).of_type(:string) }
  end

  describe "#trackable_systems" do
    subject(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }

    let(:trackable_system) { create(:trackable_system, :with_required_attributes, user:) }

    it { is_expected.to have_many(:trackable_systems).inverse_of(:user) }
    it { is_expected.to have_many(:trackable_systems).dependent(:restrict_with_exception) }
    it { expect(user.trackable_systems).to eq [] }
    it { expect(user.trackable_systems).to eq [trackable_system] }
  end

  describe "#tracking_items" do
    subject(:user) { create(:user, :with_required_attributes_as_user) }

    let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }

    it { is_expected.to have_many(:tracking_items).inverse_of(:user) }
    it { is_expected.to have_many(:tracking_items).dependent(:restrict_with_exception) }
    it { expect(user.tracking_items).to eq [] }
    it { expect(user.tracking_items).to eq [tracking_item] }
  end

  describe "#access_tokens" do
    subject(:user) { create(:user, :with_required_attributes_as_user) }

    let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

    it { is_expected.to have_many(:access_tokens) }
    it { is_expected.to have_many(:access_tokens).class_name("Doorkeeper::AccessToken") }
    it { is_expected.to have_many(:access_tokens).with_foreign_key(:resource_owner_id) }
    it { is_expected.to have_many(:access_tokens).dependent(:restrict_with_exception) }
    it { expect(user.access_tokens).to eq [] }
    it { expect(user.access_tokens).to eq [access_token] }
  end
end
