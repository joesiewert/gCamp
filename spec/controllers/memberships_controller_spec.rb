require 'rails_helper'

describe MembershipsController do

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

  describe '#create' do
    it 'redirects public users to signin' do
      project = create_project
      user = create_user
      post :create,
        project_id: project.id,
        membership: {
          project: project,
          user: user,
          role: "Member"
        }
      expect(response).to redirect_to(signin_path)
    end

    it 'creates a membership as project owner' do
      project = create_project
      user1 = create_user
      user2 = create_user
      create_membership(project, user1, role: "Owner")
      session[:user_id] = user1.id
      post :create,
      project_id: project.id,
      membership: {
        project: project,
        user: user2,
        role: "Member"
      }
      expect(response.status).to eq(200)
    end

    it 'creates a membership as admin' do
      project = create_project
      user1 = create_user(admin: true)
      user2 = create_user
      session[:user_id] = user1.id
      post :create,
      project_id: project.id,
      membership: {
        project: project,
        user: user2,
        role: "Member"
      }
      expect(response.status).to eq(200)
    end

    it 'does not create a membership as project member' do
      project = create_project
      user1 = create_user
      user2 = create_user
      create_membership(project, user1)
      session[:user_id] = user1.id
      post :create,
        project_id: project.id,
        membership: {
          project: project,
          user: user2,
          role: "Member"
        }
      expect(response.status).to eq(404)
    end

    it 'does not create a membership as non-project member' do
      project = create_project
      user = create_user
      session[:user_id] = user.id
      post :create,
        project_id: project.id,
        membership: {
          project: project,
          user: user,
          role: "Member"
        }
      expect(response.status).to eq(404)
    end
  end

  describe '#update' do
    it 'redirects public users to signin' do
      project = create_project
      user = create_user
      membership = create_membership(project, user)
      put :update,
        project_id: project.id,
        id: membership.id,
        membership: {
          project: project,
          user: user,
          role: "Member"
        }
      expect(response).to redirect_to(signin_path)
    end

    it 'updates a membership as project owner' do
      project = create_project
      user = create_user
      membership = create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      put :update,
      project_id: project.id,
      id: membership.id,
      membership: {
        project: project,
        user: user,
        role: "Member"
      }
      expect(response.status).to eq(302)
    end

    it 'updates a membership as admin' do
      project = create_project
      user = create_user(admin: true)
      membership = create_membership(project, user, role: "Owner")
      session[:user_id] = user.id
      put :update,
      project_id: project.id,
      id: membership.id,
      membership: {
        project: project,
        user: user,
        role: "Member"
      }
      expect(response.status).to eq(302)
    end

    it 'does not update a membership as project member' do
      project = create_project
      user = create_user
      membership = create_membership(project, user)
      session[:user_id] = user.id
      put :update,
        project_id: project.id,
        id: membership.id,
        membership: {
          project: project,
          user: user,
          role: "Member"
        }
      expect(response.status).to eq(404)
    end

    it 'does not update a membership as non-project member' do
      project = create_project
      user1 = create_user
      user2 = create_user
      membership = create_membership(project, user2)
      session[:user_id] = user1.id
      put :update,
        project_id: project.id,
        id: membership.id,
        membership: {
          project: project,
          user: user2,
          role: "Member"
        }
      expect(response.status).to eq(404)
    end
  end

  describe '#destroy' do
    it 'redirects public users to signin' do
      project = create_project
      user = create_user
      membership = create_membership(project, user)
      delete :destroy, project_id: project.id, id: membership.id
      expect(response).to redirect_to(signin_path)
    end

    it 'deletes a membership as project owner' do
      project = create_project
      user1 = create_user
      user2 = create_user
      create_membership(project, user1, role: "Owner")
      membership = create_membership(project, user2)
      session[:user_id] = user1.id
      delete :destroy, project_id: project.id, id: membership.id
      expect(response.status).to eq(302)
    end

    it 'deletes a membership as admin' do
      project = create_project
      user1 = create_user(admin: true)
      user2 = create_user
      membership = create_membership(project, user2)
      session[:user_id] = user1.id
      delete :destroy, project_id: project.id, id: membership.id
      expect(response.status).to eq(302)
    end

    it 'allows project member to delete his own membership' do
      project = create_project
      user = create_user
      membership = create_membership(project, user)
      session[:user_id] = user.id
      delete :destroy, project_id: project.id, id: membership.id
      expect(response.status).to eq(302)
    end

    it 'does not delete a membership as project member' do
      project = create_project
      user1 = create_user
      user2 = create_user
      create_membership(project, user1)
      membership = create_membership(project, user2)
      session[:user_id] = user1.id
      delete :destroy, project_id: project.id, id: membership.id
      expect(response.status).to eq(404)
    end

    it 'does not delete a membership as non-project member' do
      project = create_project
      user1 = create_user
      user2 = create_user
      membership = create_membership(project, user2)
      session[:user_id] = user1.id
      delete :destroy, project_id: project.id, id: membership.id
      expect(response.status).to eq(404)
    end
  end
end
