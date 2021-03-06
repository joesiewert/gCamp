class MembershipsController < ApplicationController
  before_action :set_project
  before_action :check_membership, only: [:index]
  before_action :set_projects
  before_action :check_ownership, only: [:create, :update]

  def index
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(membership_params)
    @membership.project = @project
    if @membership.save
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was added successfully."
    else
      render :index
    end
  end

  def update
    @membership = @project.memberships.find(params[:id])
    if @membership.update(membership_params)
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was updated successfully."
    else
      render :index
    end
  end

  def destroy
    @membership = @project.memberships.find(params[:id])
    if current_user.project_owner?(@project) || current_user.admin?
      if @membership.destroy
        redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was removed successfully."
      else
        flash.now[:alert] = "Unable to remove #{@membership.user.full_name}."
        render :index
      end
    elsif current_user == @membership.user
      if @membership.destroy
        redirect_to projects_path, notice: "Your membership was removed successfully."
      else
        flash.now[:alert] = "Unable to remove your membership."
        render :index
      end
    else
      raise AccessDenied
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def membership_params
      params.require(:membership).permit(:user_id, :role)
    end
end
