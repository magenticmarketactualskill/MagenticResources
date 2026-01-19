class TeamMembership < ApplicationRecord
  # Enums
  enum :role, { member: 0, lead: 1, manager: 2 }

  # Associations
  belongs_to :team
  belongs_to :resource

  # Validations
  validates :resource_id, uniqueness: { scope: :team_id, message: "is already a member of this team" }

  # Scopes
  scope :leads, -> { where(role: :lead) }
  scope :managers, -> { where(role: :manager) }
  scope :recent, -> { order(joined_at: :desc) }

  # Callbacks
  before_create :set_joined_at

  def role_label
    role.titleize
  end

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end
end
