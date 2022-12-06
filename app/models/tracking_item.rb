class TrackingItem < ApplicationRecord
  validates :name, presence: true

  belongs_to :user, inverse_of: :tracking_items
  has_many :trackings, inverse_of: :tracking_item, dependent: :restrict_with_exception
end
