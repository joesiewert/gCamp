require 'rails_helper'

describe UsersController do

  describe '#index' do
    it 'renders the application template' do
      user = create_user
      session[:user_id] = user.id
      get :index
      expect(response).to render_template('application')
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :index
      expect(response.status).to eq(200)
    end

    it 'redirects public users to signin' do
      get :index
      expect(response).to redirect_to(signin_path)
    end
  end

end
