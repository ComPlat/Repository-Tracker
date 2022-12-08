class TrackableSystem < ApplicationRecord
  has_many :from_trackings, class_name: "Tracking", inverse_of: :from_trackable_system, dependent: :restrict_with_exception
  has_many :to_trackings, class_name: "Tracking", inverse_of: :to_trackable_system, dependent: :restrict_with_exception
end
