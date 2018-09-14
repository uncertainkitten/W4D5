require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "renders the new user template" do
      get :new
      expect(response).to render_template(:new)
    end
  end
    
  describe "GET #index" do
    it "renders the users index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
  
  describe "POST #create" do
    context "with valid params" do
      it "logs the user in" do
        post :create, params: {user: {username: 'marlene', password: 'shuffleboard'}}
        user = User.find_by(username: 'marlene')
        
        expect(session[:session_token]).to eq(user.session_token)
      end
      
      it "redirects the user to show page" do
        post :create, params: {user: {username: 'marlene', password: 'shuffleboard'}}
        user = User.find_by(username: 'marlene')
        
        expect(response).to redirect_to(user_url(user))
      end
    end
    
    context "with invalid params" do
      it "validates the presence of username and password" do
        post :create, params: {user: {password: 'shuffleboard'}}
        expect(response).to render_template('new')
        expect(flash[:errors]).to be_present
      end
    end
  end
  
  describe "GET #show" do
    context "with valid params" do
      it "renders the the show template" do
        User.create!(username: 'marlene', password: 'shuffleboard')
        user = User.find_by(username: 'marlene')
        get :show, params: {id: user.id}
        expect(response).to render_template(:show)
      end
    end
    
    context "if the user doesn't exist" do
      it "doesn't work, stop trying" do 
        begin 
          get :show, params: {id: 1}
        rescue
          ActiveRecord::RecordNotFound
        end
        expect(response).not_to render_template(:show)
      end
    end
  end
    
    describe "GET #edit" do
      context "if user exist" do 
        it "renders the edit user template with valid user" do
          User.create!(username: 'marlene', password: 'shuffleboard')
          user = User.find_by(username: 'marlene')
          get :edit, params: {id: user.id}
          
          expect(response).to render_template(:edit)
        end
      end
      
      context "if user doesn't exist" do 
        it "redirects to the users index" do 
          begin 
            get :show, params: {id: 1}
          rescue
            ActiveRecord::RecordNotFound
          end
          expect(response).to redirect_to(users_url)
        end
      end
    end

    describe "PATCH #update" do 
      let (:user) { User.create!(username: 'marlene', password: 'shuffleboard') }
      before { patch :update, params: {id: user.id, user: {username: 'marlene', password: 'bridgequeen'}}}
      
      context "with valid params" do 
        it "should redirect to the user show page" do 
          expect(response).to redirect_to(user_url(user))
        end
        
        it "should update the user" do 
          expect(response).to be_success
        end
      end
      
      context "with invalid params" do 
        it "validates the presence of username and password" do
          user = nil
          begin 
            get :update, params: {id: 1}
          rescue
            ActiveRecord::RecordNotFound
          end
          expect(response).to render_template(:edit)
          expect(flash[:errors]).to be_present
        end
      end
    end
    
  describe "DELETE #destroy" do
    let (:user) { User.create!(username: 'marlene', password: 'shuffleboard') }
    before { delete :destroy, params: {id: user.id}}
    
    it "makes sure the user exists" do
      user = nil
    
      begin 
        get :show, params: {id: 1}
      rescue
        ActiveRecord::RecordNotFound
      end      
      expect(user).not_to receive(:destroy)
      expect(response).to redirect_to(users_url)
    end
    
    it "makes sure the user is DESTROYED!!!!111" do 
      user = User.find_by(username: 'marlene')
      
      expect(user).to be_nil
    end
    
    it "redirects to index after user DESTRUCTION" do
      user = User.find_by(username: 'marlene')
      expect(response).to redirect_to(users_url)
    end
  end
end
