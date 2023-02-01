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

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  # HINT: See: https://github.com/heartcombo/devise/wiki/How-To:-Find-a-user-when-you-have-their-credentials
  #            https://medium.com/@khokhanijignesh29/rails-api-doorkeeper-devise-4212115c9f0d
  def self.authenticate(email, password)
    user = User.find_for_database_authentication(email:)

    return unless user
    return unless user.valid_password?(password) # HINT: Otherwise user can login with false password.
    return unless user.confirmed? # HINT: Otherwise user can login without having confirmed his email address.

    user
  end
end
