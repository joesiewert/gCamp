require 'rails_helper'

describe TasksController do

  describe '#index' do
    it 'renders the application template' do
      project = create_project
      user = create_user
      create_membership(project, user)
      session[:user_id] = user.id
      get :index, project_id: project.id
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      project = create_project
      get :index, project_id: project.id
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to project owner' do
      project = create_project
      user = create_user
      create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      get :index, project_id: project.id
      expect(response.status).to eq(200)
    end

    it 'is visible to admin' do
      project = create_project
      user = create_user(admin: true)
      session[:user_id] = user.id
      get :index, project_id: project.id
      expect(response.status).to eq(200)
    end

    it 'is visible to project member' do
      project = create_project
      user = create_user
      create_membership(project, user)
      session[:user_id] = user.id
      get :index, project_id: project.id
      expect(response.status).to eq(200)
    end

    it 'is not visible to non-project member' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      get :index, project_id: project.id
      expect(response.status).to eq(404)
    end
  end

  describe '#new' do
    it 'renders the application template' do
      project = create_project
      user = create_user
      create_membership(project, user)
      session[:user_id] = user.id
      get :new, project_id: project.id
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      project = create_project
      get :new, project_id: project.id
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to project owner' do
      project = create_project
      user = create_user
      create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      get :new, project_id: project.id
      expect(response.status).to eq(200)
    end

    it 'is visible to admin' do
      project = create_project
      user = create_user(admin: true)
      session[:user_id] = user.id
      get :new, project_id: project.id
      expect(response.status).to eq(200)
    end

    it 'is visible to project member' do
      project = create_project
      user = create_user
      create_membership(project, user)
      session[:user_id] = user.id
      get :new, project_id: project.id
      expect(response.status).to eq(200)
    end

    it 'is not visible to non-project member' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      get :new, project_id: project.id
      expect(response.status).to eq(404)
    end
  end

  describe '#show' do
    it 'renders the application template' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user)
      session[:user_id] = user.id
      get :show, project_id: project.id, id: task.id
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      project = create_project
      task = create_task(project)
      get :show, project_id: project.id, id: task.id
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to project owner' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      get :show, project_id: project.id, id: task.id
      expect(response.status).to eq(200)
    end

    it 'is visible to admin' do
      project = create_project
      user = create_user(admin: true)
      task = create_task(project)
      session[:user_id] = user.id
      get :show, project_id: project.id, id: task.id
      expect(response.status).to eq(200)
    end

    it 'is visible to project member' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user)
      session[:user_id] = user.id
      get :show, project_id: project.id, id: task.id
      expect(response.status).to eq(200)
    end

    it 'is not visible to non-project member' do
      project = create_project
      user = create_user
      task = create_task(project)
      session[:user_id] = user.id
      get :show, project_id: project.id, id: task.id
      expect(response.status).to eq(404)
    end
  end

  describe '#edit' do
    it 'renders the application template' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user)
      session[:user_id] = user.id
      get :edit, project_id: project.id, id: task.id
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      project = create_project
      task = create_task(project)
      get :edit, project_id: project.id, id: task.id
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to project owner' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      get :edit, project_id: project.id, id: task.id
      expect(response.status).to eq(200)
    end

    it 'is visible to admin' do
      project = create_project
      user = create_user(admin: true)
      task = create_task(project)
      session[:user_id] = user.id
      get :edit, project_id: project.id, id: task.id
      expect(response.status).to eq(200)
    end

    it 'is visible to project member' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user)
      session[:user_id] = user.id
      get :edit, project_id: project.id, id: task.id
      expect(response.status).to eq(200)
    end

    it 'is not visible to non-project member' do
      project = create_project
      user = create_user
      task = create_task(project)
      session[:user_id] = user.id
      get :edit, project_id: project.id, id: task.id
      expect(response.status).to eq(404)
    end
  end

  describe '#create' do
    it 'redirects public users to signin' do
      project = create_project
      post :create,
        project_id: project.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response).to redirect_to(signin_path)
    end

    it 'creates a task as project owner' do
      project = create_project
      user = create_user
      create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      post :create,
        project_id: project.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response.status).to eq(302)
    end

    it 'creates a task as admin' do
      project = create_project
      user = create_user(admin: true)
      session[:user_id] = user.id
      post :create,
        project_id: project.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response.status).to eq(302)
    end

    it 'creates a task as project member' do
      project = create_project
      user = create_user
      create_membership(project, user)
      session[:user_id] = user.id
      post :create,
        project_id: project.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response.status).to eq(302)
    end

    it 'does not create a task as non-project member' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      post :create,
        project_id: project.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response.status).to eq(404)
    end
  end

  describe '#update' do
    it 'redirects public users to signin' do
      project = create_project
      task = create_task(project)
      put :update,
        project_id: project.id,
        id: task.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response).to redirect_to(signin_path)
    end

    it 'updates a task as project owner' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      put :update,
        project_id: project.id,
        id: task.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response.status).to eq(302)
    end

    it 'updates a task as admin' do
      project = create_project
      user = create_user(admin: true)
      task = create_task(project)
      session[:user_id] = user.id
      put :update,
        project_id: project.id,
        id: task.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response.status).to eq(302)
    end

    it 'updates a task as project member' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user)
      session[:user_id] = user.id
      put :update,
        project_id: project.id,
        id: task.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response.status).to eq(302)
    end

    it 'does not update a task as non-project member' do
      project = create_project
      user = create_user
      task = create_task(project)
      session[:user_id] = user.id
      put :update,
        project_id: project.id,
        id: task.id,
        task: {
          project: project,
          description: Faker::Lorem.sentence(1),
          due_date: Faker::Time.forward(14)
        }
      expect(response.status).to eq(404)
    end
  end

  describe '#destroy' do
    it 'redirects public users to signin' do
      project = create_project
      task = create_task(project)
      delete :destroy, project_id: project.id, id: task.id
      expect(response).to redirect_to(signin_path)
    end

    it 'deletes a task as project owner' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      delete :destroy, project_id: project.id, id: task.id
      expect(response.status).to eq(302)
    end

    it 'deletes a task as admin' do
      project = create_project
      user = create_user(admin: true)
      task = create_task(project)
      session[:user_id] = user.id
      delete :destroy, project_id: project.id, id: task.id
      expect(response.status).to eq(302)
    end

    it 'deletes a task as project member' do
      project = create_project
      user = create_user
      task = create_task(project)
      create_membership(project, user)
      session[:user_id] = user.id
      delete :destroy, project_id: project.id, id: task.id
      expect(response.status).to eq(302)
    end

    it 'does not delete a task as non-project member' do
      project = create_project
      user = create_user
      task = create_task(project)
      session[:user_id] = user.id
      delete :destroy, project_id: project.id, id: task.id
      expect(response.status).to eq(404)
    end
  end

end
