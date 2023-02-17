class TrackableSystem < ApplicationRecord
  USER_INCLUSION_ERROR_MESSAGE = "may only be of role trackable_system_admin"

  validates :name, presence: true, uniqueness: true
  validates :user, inclusion: {in: User.where(role: :trackable_system_admin), message: USER_INCLUSION_ERROR_MESSAGE}

  enum name: {radar4kit: "radar4kit",
              radar4chem: "radar4chem",
              chemotion_repository: "chemotion_repository",
              chemotion_electronic_laboratory_notebook: "chemotion_electronic_laboratory_notebook",
              nmrxiv: "nmrxiv"}

  belongs_to :user, inverse_of: :trackable_systems
  has_many :from_trackings, class_name: "Tracking",
    inverse_of: :from_trackable_system,
    foreign_key: :from_trackable_system_id,
    dependent: :restrict_with_exception
  has_many :to_trackings, class_name: "Tracking",
    inverse_of: :to_trackable_system,
    foreign_key: :to_trackable_system_id,
    dependent: :restrict_with_exception
end
