class Team < ApplicationRecord
  # Enums
  enum :team_type, { project: 0, department: 1, virtual: 2 }

  # Associations
  belongs_to :owner, class_name: "User"

  has_many :team_memberships, dependent: :destroy
  has_many :resources, through: :team_memberships

  # Validations
  validates :name, presence: true
  validates :owner, presence: true

  # Scopes
  scope :by_type, ->(type) { where(team_type: type) }
  scope :alphabetical, -> { order(name: :asc) }

  def member_count
    resources.count
  end

  def human_count
    resources.humans.count
  end

  def ai_count
    resources.ai_agents.count
  end

  def add_resource(resource, role: :member)
    team_memberships.find_or_create_by(resource: resource) do |tm|
      tm.role = role
      tm.joined_at = Time.current
    end
  end

  def remove_resource(resource)
    team_memberships.find_by(resource: resource)&.destroy
  end

  def has_resource?(resource)
    resources.include?(resource)
  end
end
