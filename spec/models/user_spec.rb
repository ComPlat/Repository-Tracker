describe User do
  subject(:user) { create :user }

  describe "columns" do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  it { is_expected.to be_valid }

  describe "#trackings" do
    subject(:user) { create :user }

    let(:tracking) { create :tracking, user: }

    it { is_expected.to have_many(:trackings) }

    it { expect(user.trackings).to eq [] }
    it { expect(user.trackings).to eq [tracking] }
  end
end
