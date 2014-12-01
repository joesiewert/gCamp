class CommentsController < ApplicationController
  before_action :set_project
  before_action :set_task

  def create
    @comment = Comment.new(comment_params)
    @comment.task = @task
    @comment.user = current_user

    if @comment.save
      redirect_to project_task_path(@project, @task)
    else
      render "tasks/show"
    end
  end

  private

  def set_task
    @task = @project.tasks.find(params[:task_id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def comment_params
    params.require(:comment).permit(:message)
  end

end
