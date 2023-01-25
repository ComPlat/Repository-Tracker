RSpec.describe Authorization::TrackingsPost do
  let(:trackings_post) { described_class.new self }

  describe ".new" do
    subject { trackings_post }

    it { is_expected.to be_a described_class }
  end
end
