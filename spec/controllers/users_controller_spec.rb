require 'rails_helper'

describe UsersController do

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
      user = create_user
      session[:user_id] = user.id
      get :show, id: user.id
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      user = create_user
      get :show, id: user.id
      expect(response).to redirect_to(signin_path)
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :show, id: user.id
      expect(response.status).to eq(200)
    end
  end

  describe '#edit' do
    it 'renders the application template' do
      user = create_user
      session[:user_id] = user.id
      get :edit, id: user.id
      expect(response).to render_template('application')
    end

    it 'redirects public users to signin' do
      user = create_user
      get :edit, id: user.id
      expect(response).to redirect_to(signin_path)
    end

    it 'allows user to edit his own user profile' do
      user = create_user
      session[:user_id] = user.id
      get :edit, id: user.id
      expect(response.status).to eq(200)
    end

    it 'does not allow user to edit another user profile' do
      user1 = create_user
      user2 = create_user
      session[:user_id] = user1.id
      get :edit, id: user2.id
      expect(response.status).to eq(404)
    end
  end

  describe '#create' do
    it 'redirects public users to signin' do
      post :create,
        user: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.free_email,
          password: Faker::Internet.password
        }
      expect(response).to redirect_to(signin_path)
    end

    it 'allows user to create a regular user' do
      user = create_user
      session[:user_id] = user.id
      post :create,
        user: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.free_email,
          password: Faker::Internet.password
        }
      expect(response.status).to eq(302)
      expect(User.last.admin).to eq(false)
    end

    it 'does not allow user to create an admin user' do
      user = create_user
      session[:user_id] = user.id
      post :create,
      user: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.free_email,
        password: Faker::Internet.password,
        admin: true
      }
      expect(response.status).to eq(302)
      expect(User.last.admin).to eq(false)
    end

    it 'allows admin user to create a regular user' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      post :create,
      user: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.free_email,
        password: Faker::Internet.password
      }
      expect(response.status).to eq(302)
      expect(User.last.admin).to eq(false)
    end

    it 'allows admin user to create an admin user' do
      user = create_user(admin: true)
      session[:user_id] = user.id
      post :create,
      user: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.free_email,
        password: Faker::Internet.password,
        admin: true
      }
      expect(response.status).to eq(302)
      expect(User.last.admin).to eq(true)
    end
  end

  describe '#update' do
    it 'redirects public users to signin' do
      user = create_user
      put :update,
        id: user.id,
        user: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.free_email
        }
      expect(response).to redirect_to(signin_path)
    end

    it 'allows user to update his own user profile' do
      user = create_user
      session[:user_id] = user.id
      put :update,
        id: user.id,
        user: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.free_email
        }
      expect(response.status).to eq(302)
    end

    it 'does not allow user to update another user profile' do
      user1 = create_user
      user2 = create_user
      session[:user_id] = user1.id
      put :update,
        id: user2.id,
        user: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.free_email
        }
      expect(response.status).to eq(404)
    end

    it 'does not allow user to make himself an admin user' do
      user = create_user
      session[:user_id] = user.id
      put :update,
        id: user.id,
        user: {
          admin: true
        }
      expect(response.status).to eq(302)
      expect(user.admin).to eq(false)
    end

    # it 'allows admin user to make regular user an admin user' do
    #   user1 = create_user(admin: true)
    #   user2 = create_user
    #   session[:user_id] = user1.id
    #   expect(user2.admin).to eq(false)
    #   put :update,
    #     id: user2.id,
    #     user: {
    #       admin: true
    #     }
    #   expect(response.status).to eq(302)
    #   expect(user2.admin).to eq(true)
    # end
  end

  describe '#destroy' do
    it 'redirects public users to signin' do
      user = create_user
      delete :destroy, id: user.id
      expect(response).to redirect_to(signin_path)
    end

    it 'allows user to delete his own user profile' do
      user = create_user
      session[:user_id] = user.id
      delete :destroy, id: user.id
      expect(response.status).to eq(302)
    end

    it 'does not allow user to delete another user profile' do
      user1 = create_user
      user2 = create_user
      session[:user_id] = user1.id
      delete :destroy, id: user2.id
      expect(response.status).to eq(404)
    end
  end

end
