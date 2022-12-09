class TrackableSystem < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  enum name: {radar4kit: "radar4kit",
              radar4chem: "radar4chem",
              chemotion_repository: "chemotion_repository",
              chemotion_electronic_laboratory_notebook: "chemotion_electronic_laboratory_notebook",
              nmrxiv: "nmrxiv"}

  has_many :from_trackings, class_name: "Tracking", inverse_of: :from_trackable_system, dependent: :restrict_with_exception
  has_many :to_trackings, class_name: "Tracking", inverse_of: :to_trackable_system, dependent: :restrict_with_exception
end
