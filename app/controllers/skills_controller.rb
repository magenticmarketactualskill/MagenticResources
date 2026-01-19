class SkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_skill, only: [:show, :edit, :update, :destroy]

  def index
    @skills = Skill.includes(:resources).alphabetical

    if params[:category].present?
      @skills = @skills.by_category(params[:category])
    end

    @categories = Skill.categories
  end

  def show
    @resources = @skill.resources.includes(:resource_skills).order("resource_skills.proficiency_level DESC")
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      redirect_to @skill, notice: "Skill was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @skill.update(skill_params)
      redirect_to @skill, notice: "Skill was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @skill.destroy
    redirect_to skills_path, notice: "Skill was successfully deleted."
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:name, :category, :description)
  end
end
