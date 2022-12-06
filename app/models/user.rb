class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  enum role: {user: 0, admin: 1}

  # HINT: See: https://github.com/heartcombo/devise/wiki/How-To:-Find-a-user-when-you-have-their-credentials
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
