class Tracking < ApplicationRecord
  # validates :date_time, presence: true
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

  before_create { self.date_time = created_at }
end
