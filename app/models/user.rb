class User < ApplicationRecord
  has_many :trackings, dependent: :restrict_with_exception
end
