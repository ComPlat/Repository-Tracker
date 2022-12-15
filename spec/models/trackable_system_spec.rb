describe TrackableSystem do
  describe "factory" do
    it { expect(build(:trackable_system)).to be_invalid }
    it { expect(build(:trackable_system, :with_required_attributes)).to be_valid }
    it { expect(create(:trackable_system, :with_required_attributes)).to be_persisted }
    it { expect(create(:trackable_system, :with_required_attributes)).to be_valid }
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
        expect(create(:trackable_system, :with_required_attributes, name: value).name).to eq value
      }
    }

    it {
      values.values.map { |value|
        expect(create(:trackable_system, :with_required_attributes, name: value).public_send("#{value}?")).to be true
      }
    }
  end

  describe "#created_at" do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  end

  describe "#updated_at" do
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end
end
