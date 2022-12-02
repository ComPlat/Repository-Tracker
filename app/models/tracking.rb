class Tracking < ApplicationRecord
  belongs_to :user
  # https://api.rubyonrails.org/classes/ActiveRecord/Enum.html
  enum :status, draft: "draft", published: "published", submitted: "submitted", default: "published"

  before_create do
    self.date_time = created_at
  end
end
