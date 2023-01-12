class TrackableSystem < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  enum name: {radar4kit: "radar4kit",
              radar4chem: "radar4chem",
              chemotion_repository: "chemotion_repository",
              chemotion_electronic_laboratory_notebook: "chemotion_electronic_laboratory_notebook",
              nmrxiv: "nmrxiv"}

  belongs_to :user, inverse_of: :trackable_systems
  has_many :from_trackings, class_name: "Tracking", inverse_of: :from_trackable_system, foreign_key: :from_trackable_system_id, dependent: :restrict_with_exception
  has_many :to_trackings, class_name: "Tracking", inverse_of: :to_trackable_system, foreign_key: :to_trackable_system_id, dependent: :restrict_with_exception

  validate :user_is_trackable_system_admin

  def user_is_trackable_system_admin
    user.blank? || user.trackable_system_admin? || errors.add(:user, "must be trackable_system_admin")
  end
end
