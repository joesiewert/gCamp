require 'rails_helper'

describe PagesController do

  describe '#index' do
    it 'renders the public template' do
      get :index
      expect(response).to render_template('public')
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :index
      expect(response.status).to eq(200)
    end

    it 'is visible to public users' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe '#about' do
    it 'renders the public template' do
      get :about
      expect(response).to render_template('public')
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :about
      expect(response.status).to eq(200)
    end

    it 'is visible to public users' do
      get :about
      expect(response.status).to eq(200)
    end
  end

  describe '#terms' do
    it 'renders the public template' do
      get :terms
      expect(response).to render_template('public')
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :terms
      expect(response.status).to eq(200)
    end

    it 'is visible to public users' do
      get :terms
      expect(response.status).to eq(200)
    end
  end

  describe '#faq' do
    it 'renders the public template' do
      get :faq
      expect(response).to render_template('public')
    end

    it 'is visible to signed in users' do
      user = create_user
      session[:user_id] = user.id
      get :faq
      expect(response.status).to eq(200)
    end

    it 'is visible to public users' do
      get :faq
      expect(response.status).to eq(200)
    end
  end

end
