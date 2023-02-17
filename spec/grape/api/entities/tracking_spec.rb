# frozen_string_literal: true

describe API::Entities::Tracking do
  let(:tracking) { create(:tracking, :with_required_attributes, :with_required_dependencies) }
  let(:tracking_entity) { described_class.new tracking }

  describe ".new" do
    subject { tracking_entity }

    it { is_expected.to be_a described_class }
  end

  describe "#serializable_hash" do
    subject(:serializable_hash) { tracking_entity.serializable_hash }

    let(:expected_result) {
      {id: tracking.id,
       date_time: tracking.date_time,
       status: tracking.status,
       metadata: tracking.metadata,
       tracking_item_name: tracking.tracking_item.name,
       from_trackable_system_name: tracking.from_trackable_system.name,
       to_trackable_system_name: tracking.to_trackable_system.name,
       owner_name: tracking.tracking_item.user.name}
    }

    it { expect(serializable_hash).to eq expected_result }
  end

  describe "#as_json" do
    subject(:as_json) { tracking_entity.as_json }

    let(:expected_result) {
      {id: tracking.id,
       date_time: tracking.date_time,
       status: tracking.status,
       metadata: tracking.metadata.deep_symbolize_keys,
       tracking_item_name: tracking.tracking_item.name,
       from_trackable_system_name: tracking.from_trackable_system.name,
       to_trackable_system_name: tracking.to_trackable_system.name,
       owner_name: tracking.tracking_item.user.name}
    }

    it { expect(as_json.deep_symbolize_keys).to eq expected_result }
  end

  describe "#to_json" do
    subject(:to_json) { tracking_entity.to_json }

    let(:expected_result) {
      {id: tracking.id,
       date_time: tracking.date_time.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
       status: tracking.status,
       metadata: tracking.metadata.deep_symbolize_keys,
       tracking_item_name: tracking.tracking_item.name,
       from_trackable_system_name: tracking.from_trackable_system.name,
       to_trackable_system_name: tracking.to_trackable_system.name,
       owner_name: tracking.tracking_item.user.name}
    }

    it { expect(JSON.parse(to_json).deep_symbolize_keys).to eq expected_result }
  end
end
