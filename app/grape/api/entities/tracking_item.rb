# frozen_string_literal: true

module API
  module Entities
    class TrackingItem < Grape::Entity
      expose :id
      expose :name
      expose :tracking_ids do |tracking_item, options|
        tracking_item.trackings.where(id: options[:tracking_ids]).ids
      end
      expose :owner_name do |tracking_item, _options|
        tracking_item.user.name
      end
    end
  end
end
