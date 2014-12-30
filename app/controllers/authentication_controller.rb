class AuthenticationController < PublicController

  def create
    user = User.find_by_email(params[:email].downcase.strip)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to_saved_url
    else
      @sign_in_error = "Username / password combination is invalid"
      render :new
    end
  end

  def redirect_to_saved_url
    redirect_to session[:saved_url] || projects_path
    session.delete(:saved_url)
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
