class Project < ApplicationRecord
  # Enums
  enum :status, { planning: 0, active: 1, on_hold: 2, completed: 3, cancelled: 4 }
  enum :priority, { low: 0, medium: 1, high: 2, critical: 3 }

  # Associations
  belongs_to :owner, class_name: "User", optional: true

  has_many :assignments, dependent: :destroy
  has_many :resources, through: :assignments

  # Validations
  validates :name, presence: true
  validates :external_id, uniqueness: { scope: :external_system }, allow_blank: true
  validate :end_date_after_start_date

  # Scopes
  scope :active_projects, -> { where(status: :active) }
  scope :by_priority, -> { order(priority: :desc) }
  scope :upcoming, -> { where("start_date > ?", Date.current) }
  scope :current, -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.current, Date.current) }
  scope :from_external, ->(system) { where(external_system: system) }

  def duration_days
    return nil unless start_date && end_date
    (end_date - start_date).to_i
  end

  def progress_percentage
    return 0 unless start_date && end_date && start_date < Date.current
    return 100 if Date.current >= end_date

    elapsed = (Date.current - start_date).to_i
    total = duration_days
    ((elapsed.to_f / total) * 100).round
  end

  def human_resources
    resources.humans
  end

  def ai_resources
    resources.ai_agents
  end

  def total_allocation
    assignments.sum(:allocation_percentage)
  end

  def synced_from_external?
    external_system.present? && external_id.present?
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date
    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
