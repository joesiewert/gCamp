require 'rails_helper'

describe RegistrationsController do

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
    it 'redirects user to new project path after signup' do
      post :create, user: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.free_email,
        password: 1234,
        password_confirmation: 1234
      }
      expect(response).to redirect_to(new_project_path)
    end
  end

end
