RSpec.describe Authorization::TrackingItemsGet do
  let(:trackings_grape_api_mock) {
    Class.new do
      def initialize(doorkeeper_token, params)
        @doorkeeper_token = doorkeeper_token
        @params = params
      end

      attr_reader :doorkeeper_token, :params
    end.new(create(:doorkeeper_access_token, :with_required_dependencies, resource_owner_id: user.id), params)
  }

  let(:tracking_items_get) { described_class.new trackings_grape_api_mock }

  describe ".new" do
    subject { tracking_items_get }

    let(:user) { create(:user, :with_required_attributes_as_user) }
    let(:params) { {} }

    it { is_expected.to be_a described_class }
  end

  describe "#all" do
    subject(:all) { tracking_items_get.all }

    let(:params) { {} }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let!(:owned_tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, user:) }

      before { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq owned_tracking_items }
      it { expect(all.size).to be < TrackingItem.count }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq tracking_items }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq tracking_items }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belong to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, :with_required_dependencies) }

      before {
        from_trackable_system = create(:trackable_system, user:, name: "radar4kit")
        to_trackable_system = create(:trackable_system, :with_required_attributes, :with_required_dependencies, name: "radar4chem")
        create(:tracking, :with_required_attributes,
          tracking_item: tracking_items.first, from_trackable_system:, to_trackable_system:)
        create(:tracking, :with_required_attributes,
          tracking_item: tracking_items.second, from_trackable_system:, to_trackable_system:)
        create(:tracking, :with_required_attributes, :with_required_dependencies,
          from_trackable_system: create(:trackable_system, :with_required_dependencies, name: "chemotion_repository"),
          to_trackable_system: create(:trackable_system, :with_required_dependencies, name: "chemotion_electronic_laboratory_notebook"))
      }

      it { is_expected.to eq tracking_items }
      it { expect(all.size).to be < TrackingItem.count }
    end
  end

  # TODO: Replicate NOT to be found record from specs for # all!
  describe "#one" do
    subject(:one) { tracking_items_get.one }

    let(:params) { {"id" => tracking_item.id} }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }

      before { create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:) }

      it { is_expected.to eq tracking_item }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

      before { create(:tracking, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq tracking_item }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

      before { create(:tracking, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq tracking_item }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belongs to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

      before do
        create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:,
          from_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies, user:))
      end

      it { is_expected.to eq tracking_item }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belongs NOT to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

      before { create(:tracking, :with_required_attributes, :with_required_dependencies) }

      it { expect { one }.to raise_error ActiveRecord::RecordNotFound }
    end
  end
end
