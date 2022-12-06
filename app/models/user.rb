class User < ApplicationRecord
  validates :name, presence: true
  validates :role, presence: true

  enum role: {user: "user", super: "super", admin: "admin"}

  has_many :tracking_items, inverse_of: :user, dependent: :restrict_with_exception
end
