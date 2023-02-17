RSpec.describe Authorization::TrackingsGet do
  let(:trackings_get) {
    doorkeeper_access_token = create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id)
    trackings_grape_api_mock = Class.new do
      def initialize(doorkeeper_token, params)
        @doorkeeper_token = doorkeeper_token
        @params = params
      end

      def error!(_message, _status) = nil

      attr_reader :doorkeeper_token, :params
    end.new(doorkeeper_access_token, params)

    described_class.new trackings_grape_api_mock
  }

  describe ".new" do
    subject { trackings_get }

    let(:user) { create(:user, :with_required_attributes_as_user) }
    let(:params) { {} }

    it { is_expected.to be_a described_class }
  end

  describe "#all" do
    subject(:all) { trackings_get.all }

    let(:params) { {} }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }
      let!(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:) }

      it { is_expected.to eq trackings }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let!(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq trackings }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let!(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq trackings }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belong to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let!(:trackings) {
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies,
          from_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies, user:))
      }

      it { is_expected.to eq trackings }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belong NOT to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }

      before do
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies)
      end

      it { is_expected.to eq [] }
    end
  end

  describe "#one" do
    subject(:one) { trackings_get.one }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }
      let(:owned_trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies, tracking_item:) }
      let(:params) { {"id" => owned_trackings.first.id} }

      it { is_expected.to eq owned_trackings.first }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let!(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }
      let(:expected_tracking) { trackings.first }
      let(:params) { {"id" => expected_tracking.id} }

      it { is_expected.to eq expected_tracking }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let!(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }
      let(:expected_tracking) { trackings.first }
      let(:params) { {"id" => expected_tracking.id} }

      it { is_expected.to eq expected_tracking }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belongs to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let!(:trackings) {
        create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies,
          from_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies, user:))
      }
      let(:expected_tracking) { trackings.first }
      let(:params) { {"id" => expected_tracking.id} }

      it { is_expected.to eq expected_tracking }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belongs NOT to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:trackings) { create_list(:tracking, 3, :with_required_attributes, :with_required_dependencies) }
      let(:expected_tracking) { trackings.first }
      let(:params) { {"id" => expected_tracking.id} }

      before do
        allow(trackings_get.instance_variable_get(:@grape_api)).to receive(:error!)
      end

      it {
        one
        expect(trackings_get.instance_variable_get(:@grape_api)).to have_received(:error!)
          .with("Couldn't find Tracking with 'id'=#{expected_tracking.id}", 404).once
      }
    end
  end
end
