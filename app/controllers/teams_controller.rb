class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :edit, :update, :destroy, :add_member, :remove_member]

  def index
    @teams = Team.includes(:owner, :resources).order(created_at: :desc)

    if params[:type].present?
      @teams = @teams.by_type(params[:type])
    end
  end

  def show
    @memberships = @team.team_memberships.includes(:resource).order(role: :desc, joined_at: :desc)
    @available_resources = Resource.active.where.not(id: @team.resource_ids)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user

    if @team.save
      redirect_to @team, notice: "Team was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: "Team was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path, notice: "Team was successfully deleted."
  end

  def add_member
    resource = Resource.find(params[:resource_id])
    role = params[:role] || :member

    if @team.add_resource(resource, role: role)
      redirect_to @team, notice: "#{resource.name} was added to the team."
    else
      redirect_to @team, alert: "Could not add resource to the team."
    end
  end

  def remove_member
    resource = Resource.find(params[:resource_id])

    if @team.remove_resource(resource)
      redirect_to @team, notice: "#{resource.name} was removed from the team."
    else
      redirect_to @team, alert: "Could not remove resource from the team."
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :description, :team_type)
  end
end
