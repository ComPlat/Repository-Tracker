class Tracking < ApplicationRecord
  belongs_to :user, inverse_of: :trackings
  # HINT: https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/Enum.html
  enum status: {draft: "draft",
                published: "published",
                submitted: "submitted",
                reviewing: "reviewing",
                pending: "pending",
                accepted: "accepted",
                reviewed: "reviewed",
                rejected: "rejected",
                deleted: "deleted"}

  before_create { self.date_time = created_at }
end
