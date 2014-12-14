class ProjectsController < ApplicationController
  before_action :ensure_current_user
  before_action :set_projects, except: [:destroy]

  def index
    #@projects = Project.all
  end

  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
    unless current_user.project_owner?(@project)
      raise AccessDenied
    end
  end

  def create
    @project = Project.new(project_params)
    @membership = Membership.new
    @membership.user = current_user
    @membership.role = "Owner"

    if @project.save
      @membership.project = @project
      if @membership.save
        redirect_to project_tasks_path(@project), notice: 'Project was successfully created.'
      else
        render :new
      end
    else
      render :new
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to project_path(@project), notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully destroyed.'
  end

  private

    def project_params
      params.require(:project).permit(:name)
    end
end
