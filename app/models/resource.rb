class Resource < ApplicationRecord
  # Enums
  enum :resource_type, { human: 0, ai_agent: 1, hybrid: 2 }
  enum :status, { available: 0, partially_available: 1, unavailable: 2, on_leave: 3 }

  # Associations
  belongs_to :created_by, class_name: "User", optional: true

  has_many :resource_skills, dependent: :destroy
  has_many :skills, through: :resource_skills

  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships

  has_many :assignments, dependent: :destroy
  has_many :projects, through: :assignments

  # Validations
  validates :name, presence: true
  validates :resource_type, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :capacity_hours, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :hourly_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :humans, -> { where(resource_type: :human) }
  scope :ai_agents, -> { where(resource_type: :ai_agent) }
  scope :active, -> { where(status: [:available, :partially_available]) }
  scope :with_skill, ->(skill) { joins(:skills).where(skills: { id: skill }) }
  scope :by_availability, -> { order(status: :asc) }

  def human?
    resource_type == "human"
  end

  def ai?
    resource_type == "ai_agent"
  end

  def display_type
    case resource_type
    when "human" then "Human"
    when "ai_agent" then "AI Agent"
    when "hybrid" then "Hybrid"
    end
  end

  def allocated_hours
    assignments.active.sum { |a| (a.allocation_percentage / 100.0) * capacity_hours }
  end

  def available_hours
    capacity_hours - allocated_hours
  end

  def availability_percentage
    return 0 if capacity_hours.zero?
    ((available_hours / capacity_hours.to_f) * 100).round
  end
end
