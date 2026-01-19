class User < ApplicationRecord
  # Enums
  enum :role, { user: 0, admin: 1 }
  enum :login_method, { email: 0, google: 1, github: 2 }

  # Associations
  has_many :owned_teams, class_name: "Team", foreign_key: :owner_id, dependent: :destroy
  has_many :owned_projects, class_name: "Project", foreign_key: :owner_id, dependent: :nullify
  has_many :created_resources, class_name: "Resource", foreign_key: :created_by_id, dependent: :nullify
  has_many :made_assignments, class_name: "Assignment", foreign_key: :assigned_by_id, dependent: :nullify

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true

  # Scopes
  scope :admins, -> { where(role: :admin) }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  before_save :downcase_email

  def display_name
    name.presence || email.split("@").first
  end

  private

  def downcase_email
    self.email = email.downcase.strip
  end
end
