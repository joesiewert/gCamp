require 'rails_helper'

describe AuthenticationController do

  describe '#new' do
    it 'renders the public template' do
      get :new
      expect(response).to render_template('public')
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :new
      expect(response.status).to eq(200)
    end

    it 'is visible to public users' do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe '#create' do
    it 'redirects user to projects path after signin' do
      user = create_user
      post :create, email: user.email, password: user.password
      expect(response).to redirect_to(projects_path)
    end
  end

end
