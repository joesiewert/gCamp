require 'rails_helper'

describe ProjectsController do

  describe '#index' do
    it 'renders the application template' do
      user = create_user
      session[:user_id] = user.id
      get :index
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      get :index
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe '#new' do
    it 'renders the application template' do
      user = create_user
      session[:user_id] = user.id
      get :new
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      get :new
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe '#show' do
    it 'renders the application template' do
      project = create_project
      user = create_user
      membership = create_membership(project, user)
      session[:user_id] = user.id
      get :show, id: project.id
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      project = create_project
      get :show, id: project.id
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to project owner' do
      project = create_project
      user = create_user
      membership = create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      get :show, id: project.id
      expect(response.status).to eq(200)
    end

    it 'is visible to admin' do
      project = create_project
      user = create_user(admin: true)
      session[:user_id] = user.id
      get :show, id: project.id
      expect(response.status).to eq(200)
    end

    it 'is visible to project member' do
      project = create_project
      user = create_user
      membership = create_membership(project, user)
      session[:user_id] = user.id
      get :show, id: project.id
      expect(response.status).to eq(200)
    end

    it 'is not visible to non-project member' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      get :show, id: project.id
      expect(response.status).to eq(404)
    end
  end

  describe '#edit' do
    it 'renders the application template' do
      project = create_project
      user = create_user
      membership = create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      get :edit, id: project.id
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      project = create_project
      get :edit, id: project.id
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to project owner' do
      project = create_project
      user = create_user
      membership = create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      get :edit, id: project.id
      expect(response.status).to eq(200)
    end

    it 'is visible to admin' do
      project = create_project
      user = create_user(admin: true)
      session[:user_id] = user.id
      get :edit, id: project.id
      expect(response.status).to eq(200)
    end

    it 'is not visible to project member' do
      project = create_project
      user = create_user
      membership = create_membership(project, user)
      session[:user_id] = user.id
      get :edit, id: project.id
      expect(response.status).to eq(404)
    end

    it 'is not visible to non-project member' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      get :edit, id: project.id
      expect(response.status).to eq(404)
    end
  end

  describe '#create' do
    it 'redirects public users to signin' do
      post :create,
        project: {
          name: Faker::App.name
        }
      expect(response).to redirect_to(signin_path)
    end

    it 'creates a project as signed in user' do
      user = create_user
      session[:user_id] = user.id
      post :create,
        project: {
          name: Faker::App.name
        }
      expect(response.status).to eq(302)
    end

    it 'redirects user to project tasks path after project creation' do
      user = create_user
      session[:user_id] = user.id
      post :create,
        project: {
          name: Faker::App.name
        }
      expect(response).to redirect_to(project_tasks_path(Project.first))
    end
  end

  describe '#update' do
    it 'redirects public users to signin' do
      project = create_project
      put :update,
        id: project.id,
        project: {
          name: Faker::App.name
        }
      expect(response).to redirect_to(signin_path)
    end

    it 'updates project as project owner' do
      project = create_project
      user = create_user
      membership = create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      put :update,
        id: project.id,
        project: {
          name: Faker::App.name
        }
      expect(response.status).to eq(302)
    end

    it 'updates project as admin' do
      project = create_project
      user = create_user(admin: true)
      session[:user_id] = user.id
      put :update,
        id: project.id,
        project: {
          name: Faker::App.name
        }
      expect(response.status).to eq(302)
    end

    it 'does not update project as project member' do
      project = create_project
      user = create_user
      membership = create_membership(project, user)
      session[:user_id] = user.id
      put :update,
        id: project.id,
        project: {
          name: Faker::App.name
        }
      expect(response.status).to eq(404)
    end

    it 'does not update project as non-project member' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      put :update,
        id: project.id,
        project: {
          name: Faker::App.name
        }
      expect(response.status).to eq(404)
    end
  end

  describe '#destroy' do
    it 'redirects public users to signin' do
      project = create_project
      delete :destroy, id: project.id
      expect(response).to redirect_to(signin_path)
    end

    it 'deletes a project as project owner' do
      project = create_project
      user = create_user
      create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      delete :destroy, id: project.id
      expect(response.status).to eq(302)
    end

    it 'deletes a project as admin' do
      project = create_project
      user = create_user(admin: true)
      session[:user_id] = user.id
      delete :destroy, id: project.id
      expect(response.status).to eq(302)
    end

    it 'does not delete a project as project member' do
      project = create_project
      user = create_user
      create_membership(project, user)
      session[:user_id] = user.id
      delete :destroy, id: project.id
      expect(response.status).to eq(404)
    end

    it 'does not delete a project as non-project member' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      delete :destroy, id: project.id
      expect(response.status).to eq(404)
    end
  end

end
