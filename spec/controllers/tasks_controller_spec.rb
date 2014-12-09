require 'rails_helper'

describe TasksController do

  describe '#index' do
    it 'renders the application template' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      get :index, project_id: project.id
      expect(response).to render_template('application')
    end

    it 'is visible to signed in users' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      get :index, project_id: project.id
      expect(response.status).to eq(200)
    end

    it 'redirects public users to signin' do
      project = create_project
      get :index, project_id: project.id
      expect(response).to redirect_to(signin_path)
    end
  end

end
