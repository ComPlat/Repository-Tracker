class Tracking < ApplicationRecord
  belongs_to :user
  # HINT: https://api.rubyonrails.org/classes/ActiveRecord/Enum.html
  enum status: {draft: "draft", published: "published", submitted: "submitted"}

  before_create { self.date_time = created_at }
end
