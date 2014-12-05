class RegistrationsController < PublicController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation))
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      @sign_up_errors = @user.errors.full_messages
      render :new
    end
  end
end
