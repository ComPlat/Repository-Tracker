class TrackingItem < ApplicationRecord
  USER_INCLUSION_ERROR_MESSAGE = "may only be of role user"

  validates :name, presence: true, uniqueness: true
  validates :user, inclusion: {in: User.where(role: :user), message: USER_INCLUSION_ERROR_MESSAGE}

  belongs_to :user, inverse_of: :tracking_items
  has_many :trackings, inverse_of: :tracking_item, dependent: :restrict_with_exception
end
