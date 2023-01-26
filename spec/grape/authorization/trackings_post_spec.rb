RSpec.describe Authorization::TrackingsPost do
  let(:trackings_post) { described_class.new self }
  let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

  describe ".new" do
    subject { trackings_post }

    it { is_expected.to be_a described_class }
  end

  describe "#authorized?" do
    subject(:authorized) { trackings_post.authorized? }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }

      before do
        allow(trackings_post).to receive(:current_user).and_return(user)
        allow(trackings_post).to receive(:error!)
      end

      it {
        authorized
        expect(trackings_post).to have_received(:error!).with(described_class::MSG_TRACKABLE_SYSTEM_ADMIN, 401)
      }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }

      before do
        allow(trackings_post).to receive(:current_user).and_return(user)
        allow(trackings_post).to receive(:error!)
      end

      it {
        authorized
        expect(trackings_post).to have_received(:error!).with(described_class::MSG_TRACKABLE_SYSTEM_ADMIN, 401)
      }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }

      before do
        allow(trackings_post).to receive(:current_user).and_return(user)
        allow(trackings_post).to receive(:error!)
      end

      it {
        authorized
        expect(trackings_post).to have_received(:error!).with(described_class::MSG_TRACKABLE_SYSTEM_ADMIN, 401)
      }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin is also the owner of from_trackable_system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }

      before do
        allow(trackings_post).to receive(:current_user).and_return(user)
        allow(trackings_post).to receive(:params).and_return("from_trackable_system_name")
        allow(trackings_post).to receive(:trackable_system_owner?).and_return(user)
      end

      it { is_expected.to be true }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin is NOT the owner of from_trackable_system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }

      before do
        allow(trackings_post).to receive(:current_user).and_return(user)
        allow(trackings_post).to receive(:params).and_return("from_trackable_system_name")
        allow(trackings_post).to receive(:trackable_system_owner?).and_return(false)
        allow(trackings_post).to receive(:error!)
      end

      it {
        authorized
        expect(trackings_post).to have_received(:error!).with(described_class::MSG_TRACKABLE_SYSTEM_OWNER, 401)
      }
    end
  end
end
