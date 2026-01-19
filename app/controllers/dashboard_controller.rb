class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @resources_count = Resource.count
    @humans_count = Resource.humans.count
    @ai_agents_count = Resource.ai_agents.count
    @available_count = Resource.active.count

    @teams_count = Team.count
    @projects_count = Project.count
    @active_projects_count = Project.active_projects.count

    @recent_resources = Resource.includes(:skills).order(created_at: :desc).limit(5)
    @active_assignments = Assignment.active.includes(:resource, :project).limit(10)

    @skills_by_category = Skill.group(:category).count
  end
end
