describe TrackableSystem do
  describe "factory" do
    it { expect(build(:trackable_system)).to be_invalid }
    it { expect(build(:trackable_system, :with_required_attributes)).to be_invalid }
    it { expect(build(:trackable_system, :with_required_dependencies)).to be_invalid }
    it { expect(create(:trackable_system, :with_required_attributes, :with_required_dependencies)).to be_persisted }
    it { expect(create(:trackable_system, :with_required_attributes, :with_required_dependencies)).to be_valid }
  end

  describe "#id" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
  end

  describe "#name" do
    let(:values) {
      {radar4kit: "radar4kit",
       radar4chem: "radar4chem",
       chemotion_repository: "chemotion_repository",
       chemotion_electronic_laboratory_notebook: "chemotion_electronic_laboratory_notebook",
       nmrxiv: "nmrxiv"}
    }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_db_column(:name).of_type(:enum) }
    it { is_expected.to define_enum_for(:name).with_values(values).backed_by_column_of_type(:enum) }
    it { expect { build(:trackable_system, name: "invalid_name") }.to raise_error ArgumentError, "'invalid_name' is not a valid name" }

    it {
      values.values.map { |value|
        expect(create(:trackable_system, :with_required_attributes, :with_required_dependencies, name: value).name).to eq value
      }
    }

    it {
      values.values.map { |value|
        expect(create(:trackable_system, :with_required_attributes, :with_required_dependencies, name: value).public_send("#{value}?")).to be true
      }
    }
  end

  describe "#created_at" do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  end

  describe "#updated_at" do
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe "#from_trackings" do
    subject(:trackable_system) { create(:trackable_system, :with_required_attributes, :with_required_dependencies) }

    let(:tracking) { create(:tracking, :with_required_attributes, :with_required_dependencies, from_trackable_system: trackable_system) }

    it { is_expected.to have_many(:from_trackings).inverse_of(:from_trackable_system).with_foreign_key(:from_trackable_system_id).dependent(:restrict_with_exception).class_name("Tracking") }
    it { expect(trackable_system.from_trackings).to eq [] }
    it { expect(trackable_system.from_trackings).to eq [tracking] }
  end

  describe "#to_trackings" do
    subject(:trackable_system) { create(:trackable_system, :with_required_attributes, :with_required_dependencies) }

    let(:tracking) { create(:tracking, :with_required_attributes, :with_required_dependencies, to_trackable_system: trackable_system) }

    it { is_expected.to have_many(:to_trackings).inverse_of(:to_trackable_system).with_foreign_key(:to_trackable_system_id).dependent(:restrict_with_exception).class_name("Tracking") }
    it { expect(trackable_system.to_trackings).to eq [] }
    it { expect(trackable_system.to_trackings).to eq [tracking] }
  end

  describe "#user" do
    let(:user) { create(:user, :with_required_attributes) }

    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to belong_to(:user).inverse_of(:trackable_systems) }
    it { expect(create(:trackable_system, :with_required_attributes, user:).user).to eq user }

    it {
      expect { create(:trackable_system, :with_required_attributes, user: nil) }
        .to raise_error ActiveRecord::RecordInvalid, "Validation failed: User must exist"
    }
  end
end
