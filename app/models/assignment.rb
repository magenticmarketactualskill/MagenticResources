class Assignment < ApplicationRecord
  # Enums
  enum :status, { pending: 0, active: 1, completed: 2, cancelled: 3 }

  # Associations
  belongs_to :project
  belongs_to :resource
  belongs_to :assigned_by, class_name: "User", optional: true

  # Validations
  validates :resource_id, uniqueness: { scope: :project_id, message: "is already assigned to this project" }
  validates :allocation_percentage, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 100
  }, allow_nil: true
  validate :end_date_after_start_date
  validate :resource_has_capacity, on: :create

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :for_resource, ->(resource) { where(resource: resource) }
  scope :for_project, ->(project) { where(project: project) }
  scope :current, -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.current, Date.current) }
  scope :by_allocation, -> { order(allocation_percentage: :desc) }

  def allocated_hours
    return 0 unless resource && allocation_percentage
    (allocation_percentage / 100.0) * resource.capacity_hours
  end

  def duration_days
    return nil unless start_date && end_date
    (end_date - start_date).to_i
  end

  def active?
    status == "active" &&
      (start_date.nil? || start_date <= Date.current) &&
      (end_date.nil? || end_date >= Date.current)
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date
    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def resource_has_capacity
    return unless resource && allocation_percentage

    current_allocation = resource.assignments.active.where.not(id: id).sum(:allocation_percentage)
    if current_allocation + allocation_percentage > 100
      errors.add(:allocation_percentage, "exceeds resource's available capacity (#{100 - current_allocation}% available)")
    end
  end
end
