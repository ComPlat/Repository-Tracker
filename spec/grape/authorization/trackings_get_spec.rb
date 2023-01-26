RSpec.describe Authorization::TrackingsGet do
  let(:trackings_get) { described_class.new self }
  let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id) }

  describe ".new" do
    subject { trackings_get }

    it { is_expected.to be_a described_class }
  end

  describe "#all" do
    subject(:all) { trackings_get.all }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:) }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("user")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
      end

      it { is_expected.to eq trackings }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("super")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
      end

      it { is_expected.to eq trackings }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("admin")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
      end

      it { is_expected.to eq trackings }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belong to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:trackings) {
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies,
          from_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies, user:))
      }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("trackable_system_admin")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
      end

      it { is_expected.to eq trackings }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belong NOT to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("trackable_system_admin")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
      end

      it { is_expected.to eq [] }
    end
  end

  describe "#one" do
    subject(:one) { trackings_get.one }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:) }
      let(:expected_tracking) { trackings.first }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("user")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
        allow(trackings_get).to receive(:id).and_return(expected_tracking.id)
      end

      it { is_expected.to eq expected_tracking }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }
      let(:expected_tracking) { trackings.first }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("super")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
        allow(trackings_get).to receive(:id).and_return(expected_tracking.id)
      end

      it { is_expected.to eq expected_tracking }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }
      let(:expected_tracking) { trackings.first }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("admin")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
        allow(trackings_get).to receive(:id).and_return(expected_tracking.id)
      end

      it { is_expected.to eq expected_tracking }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belongs to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:trackings) {
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies,
          from_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies, user:))
      }
      let(:expected_tracking) { trackings.first }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("trackable_system_admin")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
        allow(trackings_get).to receive(:id).and_return(expected_tracking.id)
      end

      it { is_expected.to eq expected_tracking }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belongs NOT to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }
      let(:expected_tracking) { trackings.first }

      before do
        trackings
        allow(trackings_get).to receive(:role).and_return("trackable_system_admin")
        allow(trackings_get).to receive(:doorkeeper_token).and_return(access_token)
        allow(trackings_get).to receive(:id).and_return(expected_tracking.id)
      end

      it { expect { one }.to raise_error ActiveRecord::RecordNotFound }
    end
  end
end
