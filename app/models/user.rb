class User < ApplicationRecord
  validates :name, presence: true
  validates :role, presence: true
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP

  enum role: {user: "user", super: "super", admin: "admin"}

  has_many :tracking_items, inverse_of: :user, dependent: :restrict_with_exception

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # HINT: See: https://github.com/heartcombo/devise/wiki/How-To:-Find-a-user-when-you-have-their-credentials
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
