RSpec.describe Authorization::TrackingsGet do
  let(:trackings_get) { described_class.new self }

  describe ".new" do
    subject { trackings_get }

    it { is_expected.to be_a described_class }
  end
end
