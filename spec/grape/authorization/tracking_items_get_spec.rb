RSpec.describe Authorization::TrackingItemsGet do
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

  let(:tracking_items_get) { described_class.new grape_api_mock }

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

  describe "#one" do
    subject(:one) { tracking_items_get.one }

    context "when user role is :user and item is owned" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:params) { {"name" => owned_tracking_items.first.name} }
      let(:owned_tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, user:) }

      before { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq owned_tracking_items.first }
    end

    context "when user role is :user and item is NOT owned" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:params) { {"name" => not_owned_tracking_item.name} }
      let(:not_owned_tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

      before {
        create_list(:tracking_item, 2, :with_required_attributes, user:)

        allow(grape_api_mock).to receive(:error!)
      }

      it {
        one
        expect(grape_api_mock).to have_received(:error!).with("Couldn't find TrackingItem with 'name'=#{not_owned_tracking_item.name}", 404).once
      }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }
      let(:params) { {"name" => tracking_item.name} }

      before { create(:tracking, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq tracking_item }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }
      let(:params) { {"name" => tracking_item.name} }

      before { create(:tracking, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq tracking_item }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belong to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, :with_required_dependencies) }
      let(:params) { {"name" => tracking_items.first.name} }

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

      it { is_expected.to eq tracking_items.first }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin does NOT belong to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, :with_required_dependencies) }
      let(:params) { {"name" => tracking_items.first.name} }

      before {
        from_trackable_system = create(:trackable_system, :with_required_dependencies, name: "radar4kit")
        to_trackable_system = create(:trackable_system, :with_required_attributes, :with_required_dependencies, name: "radar4chem")
        create(:tracking, :with_required_attributes,
          tracking_item: tracking_items.first, from_trackable_system:, to_trackable_system:)
        create(:tracking, :with_required_attributes,
          tracking_item: tracking_items.second, from_trackable_system:, to_trackable_system:)
        create(:tracking, :with_required_attributes, :with_required_dependencies,
          from_trackable_system: create(:trackable_system, :with_required_dependencies, name: "chemotion_repository"),
          to_trackable_system: create(:trackable_system, :with_required_dependencies, name: "chemotion_electronic_laboratory_notebook"))

        allow(grape_api_mock).to receive(:error!)
      }

      it {
        one
        expect(grape_api_mock).to have_received(:error!).with("Couldn't find TrackingItem with 'name'=#{tracking_items.first.name}", 404).once
      }
    end
  end

  describe "#tracking_ids" do
    subject(:tracking_ids) { tracking_items_get.tracking_ids }

    let(:params) { {} }

    context "when user role is :user" do
      let(:user) { create(:user, :with_required_attributes_as_user) }
      let(:owned_tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, user:) }
      let!(:owned_trackings) do
        owned_tracking_items.map { |tracking_item|
          create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:)
        }
      end

      before { create(:tracking, :with_required_attributes, :with_required_dependencies) }

      it { is_expected.to eq owned_trackings.pluck :id }
    end

    context "when user role is :super" do
      let(:user) { create(:user, :with_required_attributes_as_super) }
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, :with_required_dependencies) }
      let!(:trackings) do
        tracking_items.map { |tracking_item|
          create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:)
        }
      end

      it { is_expected.to eq trackings.pluck :id }
    end

    context "when user role is :admin" do
      let(:user) { create(:user, :with_required_attributes_as_admin) }
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, :with_required_dependencies) }
      let!(:trackings) do
        tracking_items.map { |tracking_item|
          create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:)
        }
      end

      it { is_expected.to eq trackings.pluck :id }
    end

    context "when user role is :trackable_system_admin and trackable_system_admin belong to a trackable system" do
      let(:user) { create(:user, :with_required_attributes_as_trackable_system_admin) }
      let(:tracking_items) { create_list(:tracking_item, 2, :with_required_attributes, :with_required_dependencies) }
      let!(:trackings) do
        from_trackable_system = create(:trackable_system, user:, name: "radar4kit")
        to_trackable_system = create(:trackable_system, :with_required_attributes, :with_required_dependencies, name: "radar4chem")

        tracking_items.map { |tracking_item|
          create(:tracking, :with_required_attributes, from_trackable_system:, to_trackable_system:, tracking_item:)
        }
      end

      before {
        create(:tracking, :with_required_attributes, :with_required_dependencies,
          from_trackable_system: create(:trackable_system, :with_required_dependencies, name: "chemotion_repository"),
          to_trackable_system: create(:trackable_system, :with_required_dependencies, name: "chemotion_electronic_laboratory_notebook"))
      }

      it { is_expected.to eq trackings.pluck :id }
    end
  end
end
