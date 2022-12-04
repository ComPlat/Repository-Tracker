describe User do
  subject(:user) { create(:user) }

  it { is_expected.to be_valid }
  it { is_expected.to have_many(:trackings) }
end
