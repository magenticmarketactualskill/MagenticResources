class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.includes(:owner, :resources).order(created_at: :desc)

    if params[:status].present?
      @projects = @projects.where(status: params[:status])
    end

    if params[:priority].present?
      @projects = @projects.where(priority: params[:priority])
    end
  end

  def show
    @assignments = @project.assignments.includes(:resource, :assigned_by).order(created_at: :desc)
    @available_resources = Resource.active.where.not(id: @project.resource_ids)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully deleted."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name, :description, :status, :priority,
      :start_date, :end_date, :external_id, :external_system
    )
  end
end
