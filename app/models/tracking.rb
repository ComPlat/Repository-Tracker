class Tracking < ApplicationRecord
  validates :metadata, presence: true
  validates :status, presence: true

  enum status: {draft: "draft",
                published: "published",
                submitted: "submitted",
                reviewing: "reviewing",
                pending: "pending",
                accepted: "accepted",
                reviewed: "reviewed",
                rejected: "rejected",
                deleted: "deleted"}

  belongs_to :tracking_item, inverse_of: :trackings
  belongs_to :from_trackable_system, class_name: "TrackableSystem", inverse_of: :from_trackings
  belongs_to :to_trackable_system, class_name: "TrackableSystem", inverse_of: :to_trackings

  before_create { self.date_time = created_at }
end
