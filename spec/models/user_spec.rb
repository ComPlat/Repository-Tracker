describe User do
  subject(:user) { create :user }

  describe "columns" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  it { is_expected.to be_valid }
  it { is_expected.to have_many(:trackings) }
end
