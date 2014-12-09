require 'rails_helper'

describe ProjectsController do

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

  describe '#create' do
    it 'redirects user to project tasks path after project creation' do
      user = create_user
      session[:user_id] = user.id
      post :create, project: {
        name: Faker::App.name
      }
      expect(response).to redirect_to(project_tasks_path(Project.first))
    end
  end

end
