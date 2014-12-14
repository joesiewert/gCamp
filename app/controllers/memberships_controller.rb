class MembershipsController < ApplicationController
  before_action :set_project
  before_action :check_membership, only: [:index]
  before_action :set_projects, only: [:index, :create]
  before_action :check_ownership, only: [:create, :update, :destroy]

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
    @membership.destroy
    redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was removed successfully."
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def membership_params
      params.require(:membership).permit(:user_id, :role)
    end
end
