class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_projects, except: [:destroy]
  before_action :check_membership, only: [:show]
  before_action :check_ownership, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @project = Project.new
  end

  def show
  end

  def edit
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
    if @project.update(project_params)
      redirect_to project_path(@project), notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    #Sets all owners to members so before_destroy on
    #membership model won't stop the destroy
    @project.memberships.each do |membership|
      if membership.role == "Owner"
        membership.role = "Member"
      end
    end

    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully destroyed.'
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name)
    end
end
