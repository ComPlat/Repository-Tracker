class User < ApplicationRecord
  validates :name, presence: true
  validates :role, presence: true
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP

  enum role: {user: "user", super: "super", admin: "admin", trackable_system_admin: "trackable_system_admin"}

  has_many :trackable_systems, inverse_of: :user, dependent: :restrict_with_exception
  has_many :tracking_items, inverse_of: :user, dependent: :restrict_with_exception

  # HINT: Model access_token is constructed by Doorkeeper and therefore, it does NOT have an user dependency.
  # rubocop:disable Rails/InverseOf
  has_many :access_tokens,
    class_name: "Doorkeeper::AccessToken",
    foreign_key: :resource_owner_id,
    dependent: :restrict_with_exception
  # rubocop:enable Rails/InverseOf

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # HINT: See: https://github.com/heartcombo/devise/wiki/How-To:-Find-a-user-when-you-have-their-credentials
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
