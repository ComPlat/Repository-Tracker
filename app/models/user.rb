class User < ApplicationRecord
  has_many :trackings, inverse_of: :user, dependent: :restrict_with_exception
end
