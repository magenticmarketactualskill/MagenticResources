class ResourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  def index
    @resources = Resource.includes(:skills, :teams).order(created_at: :desc)

    if params[:type].present?
      @resources = @resources.where(resource_type: params[:type])
    end

    if params[:status].present?
      @resources = @resources.where(status: params[:status])
    end

    if params[:skill_id].present?
      @resources = @resources.joins(:resource_skills).where(resource_skills: { skill_id: params[:skill_id] })
    end

    respond_to do |format|
      format.html
      format.json { render json: @resources }
    end
  end

  def show
    @assignments = @resource.assignments.includes(:project).order(created_at: :desc)
    @skills = @resource.resource_skills.includes(:skill).by_proficiency
    @teams = @resource.team_memberships.includes(:team)
  end

  def new
    @resource = Resource.new
    @skills = Skill.alphabetical
  end

  def create
    @resource = Resource.new(resource_params)
    @resource.created_by = current_user

    if @resource.save
      update_skills if params[:skill_ids].present?
      redirect_to @resource, notice: "Resource was successfully created."
    else
      @skills = Skill.alphabetical
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @skills = Skill.alphabetical
  end

  def update
    if @resource.update(resource_params)
      update_skills if params[:skill_ids]
      redirect_to @resource, notice: "Resource was successfully updated."
    else
      @skills = Skill.alphabetical
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @resource.destroy
    redirect_to resources_path, notice: "Resource was successfully deleted."
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
  end

  def resource_params
    params.require(:resource).permit(
      :name, :resource_type, :status, :email, :avatar_url,
      :description, :hourly_rate, :capacity_hours, :timezone
    )
  end

  def update_skills
    skill_ids = params[:skill_ids].reject(&:blank?).map(&:to_i)
    current_skill_ids = @resource.resource_skills.pluck(:skill_id)

    # Remove skills no longer selected
    @resource.resource_skills.where(skill_id: current_skill_ids - skill_ids).destroy_all

    # Add new skills
    (skill_ids - current_skill_ids).each do |skill_id|
      @resource.resource_skills.create(skill_id: skill_id, proficiency_level: :intermediate)
    end
  end
end
