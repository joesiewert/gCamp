class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :set_projects

  private
    def current_user
      if session[:user_id]
        User.find_by(id: session[:user_id])
      end
    end

    def set_projects
      current_user_projects = current_user.memberships.pluck(:project_id)
      @projects = Project.where(id: current_user_projects)
    end

    def ensure_current_user
      unless current_user
        redirect_to signin_path, notice: 'You must be logged in to access that action.'
      end
    end

    class AccessDenied < StandardError
    end

    def render_404
      render 'public/404.html', status: 404, layout: false
    end

    rescue_from AccessDenied, with: :render_404
end
