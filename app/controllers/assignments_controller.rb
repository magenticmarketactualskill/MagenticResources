class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  def index
    @assignments = @project.assignments.includes(:resource, :assigned_by)
  end

  def show
  end

  def new
    @assignment = @project.assignments.build
    @available_resources = Resource.active.where.not(id: @project.resource_ids)
  end

  def create
    @assignment = @project.assignments.build(assignment_params)
    @assignment.assigned_by = current_user

    if @assignment.save
      respond_to do |format|
        format.html { redirect_to @project, notice: "#{@assignment.resource.name} was assigned to the project." }
        format.turbo_stream
      end
    else
      @available_resources = Resource.active.where.not(id: @project.resource_ids)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_resources = Resource.active
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to @project, notice: "Assignment was successfully updated."
    else
      @available_resources = Resource.active
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    resource_name = @assignment.resource.name
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to @project, notice: "#{resource_name} was removed from the project." }
      format.turbo_stream
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_assignment
    @assignment = @project.assignments.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(
      :resource_id, :role, :allocation_percentage,
      :start_date, :end_date, :status, :notes
    )
  end
end
