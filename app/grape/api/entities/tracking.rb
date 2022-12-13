# frozen_string_literal: true

module API
  module Entities
    class Tracking < Grape::Entity
      expose :id
      expose :date_time
      expose :status
      expose :metadata
      expose :tracking_item_name do |tracking, _options|
        tracking.tracking_item.name
      end
      expose :from_trackable_system_name do |tracking, _options|
        tracking.from_trackable_system.name
      end
      expose :to_trackable_system_name do |tracking, _options|
        tracking.to_trackable_system.name
      end
      expose :owner_name do |tracking, _options|
        tracking.tracking_item.user.name
      end
    end
  end
end
