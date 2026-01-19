class Skill < ApplicationRecord
  # Associations
  has_many :resource_skills, dependent: :destroy
  has_many :resources, through: :resource_skills

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :category, presence: true

  # Scopes
  scope :by_category, ->(category) { where(category: category) }
  scope :alphabetical, -> { order(name: :asc) }
  scope :popular, -> { left_joins(:resource_skills).group(:id).order("COUNT(resource_skills.id) DESC") }

  # Category constants
  CATEGORIES = %w[
    programming
    design
    management
    communication
    analysis
    testing
    devops
    data
    ai_ml
    other
  ].freeze

  def self.categories
    CATEGORIES
  end

  def resource_count
    resources.count
  end
end
