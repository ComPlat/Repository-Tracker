describe Tracking do
  let(:user) { build(:user) }

  describe "#valid?" do
    subject(:tracking) { build(:tracking, :with_realistic_attributes, user:) }

    it { is_expected.to be_valid }
  end

  describe "#date_time" do
    # HINT Test before_create hook
    subject { tracking.date_time }

    let(:tracking) { create(:tracking, user:) }

    it { is_expected.to eq tracking.created_at }
  end

  describe "#draft?" do
    context "without set status (use default status 'draft' from database)" do
      subject { tracking.draft? }

      let(:tracking) { described_class.new(user:) }

      before do
        tracking.save
      end

      it { is_expected.to be true }
    end
  end
end
