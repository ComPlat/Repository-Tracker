RSpec.describe Authorization::TrackingsPost do
  let(:grape_api_mock) {
    doorkeeper_access_token = create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id)
    Class.new do
      def initialize(doorkeeper_token, params)
        @doorkeeper_token = doorkeeper_token
        @params = params
      end

      def error!(_message, _status) = nil

      attr_reader :doorkeeper_token, :params
    end.new(doorkeeper_access_token, params)
  }
  let(:trackings_post) { described_class.new grape_api_mock }

  describe ".new" do
    subject { trackings_post }

    let(:user) { create(:user, :with_required_attributes_as_user) }
    let(:params) { {} }

    it { is_expected.to be_a described_class }
  end

  describe "#authorized?" do
    subject(:authorized) { trackings_post.authorized? }

    before { allow(grape_api_mock).to receive(:error!) }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:params) { {} }

      it {
        authorized
        expect(grape_api_mock).to have_received(:error!).with(described_class::MSG_TRACKABLE_SYSTEM_ADMIN, 401).once
      }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let(:params) { {} }

      it {
        authorized
        expect(grape_api_mock).to have_received(:error!).with(described_class::MSG_TRACKABLE_SYSTEM_ADMIN, 401).once
      }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let(:params) { {} }

      it {
        authorized
        expect(grape_api_mock).to have_received(:error!).with(described_class::MSG_TRACKABLE_SYSTEM_ADMIN, 401).once
      }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin is also the owner of from_trackable_system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:trackable_system) { create(:trackable_system, :with_required_attributes, user:) }
      let(:params) { {"from_trackable_system_name" => trackable_system.name} }

      it { is_expected.to be true }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin is NOT the owner of from_trackable_system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:trackable_system) { create(:trackable_system, :with_required_attributes, :with_required_dependencies) }
      let(:params) { {"from_trackable_system_name" => trackable_system.name} }

      it {
        authorized
        expect(grape_api_mock).to have_received(:error!).with(described_class::MSG_TRACKABLE_SYSTEM_OWNER, 401).once
      }
    end
  end
end
