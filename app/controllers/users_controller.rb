class UsersController < ApplicationController
  before_action :set_projects, except: [:destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy

    if @user.comments.present?
      @user.comments.each do |comment|
        comment.user_id = nil
        comment.save
      end
    end

    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully deleted.' }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      if current_user.admin?
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :tracker_token, :admin)
      else
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :tracker_token)
      end
    end

    def check_user
      unless current_user == @user || current_user.admin?
        raise AccessDenied
      end
    end
end
