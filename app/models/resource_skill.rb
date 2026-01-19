class ResourceSkill < ApplicationRecord
  # Enums
  enum :proficiency_level, { beginner: 1, intermediate: 2, advanced: 3, expert: 4 }

  # Associations
  belongs_to :resource
  belongs_to :skill

  # Validations
  validates :resource_id, uniqueness: { scope: :skill_id, message: "already has this skill" }
  validates :proficiency_level, presence: true
  validates :years_experience, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :certified, -> { where(certified: true) }
  scope :by_proficiency, -> { order(proficiency_level: :desc) }
  scope :experts, -> { where(proficiency_level: :expert) }

  def proficiency_label
    case proficiency_level
    when "beginner" then "Beginner"
    when "intermediate" then "Intermediate"
    when "advanced" then "Advanced"
    when "expert" then "Expert"
    end
  end
end
