# frozen_string_literal: true

describe API::Entities::TrackingItem do
  let(:tracking) { create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:) }
  let(:tracking_item) { create(:tracking_item, :with_required_attributes, :with_required_dependencies) }

  let(:tracking_item_entity) { described_class.new tracking_item, tracking_ids: [tracking.id] }

  before { create(:tracking, :with_required_attributes, :with_required_dependencies, tracking_item:) }

  describe ".new" do
    subject { tracking_item_entity }

    it { is_expected.to be_a described_class }
  end

  describe "#serializable_hash" do
    subject(:serializable_hash) { tracking_item_entity.serializable_hash }

    let(:expected_result) {
      {id: tracking_item.id,
       name: tracking_item.name,
       tracking_ids: [tracking.id],
       owner_name: tracking_item.user.name}
    }

    it { expect(serializable_hash).to eq expected_result }
  end

  describe "#as_json" do
    subject(:as_json) { tracking_item_entity.as_json }

    let(:expected_result) {
      {id: tracking_item.id,
       name: tracking_item.name,
       tracking_ids: [tracking.id],
       owner_name: tracking_item.user.name}
    }

    it { expect(as_json.deep_symbolize_keys).to eq expected_result }
  end

  describe "#to_json" do
    subject(:to_json) { tracking_item_entity.to_json }

    let(:expected_result) {
      {id: tracking_item.id,
       name: tracking_item.name,
       tracking_ids: [tracking.id],
       owner_name: tracking_item.user.name}
    }

    it { expect(JSON.parse(to_json).deep_symbolize_keys).to eq expected_result }
  end
end
