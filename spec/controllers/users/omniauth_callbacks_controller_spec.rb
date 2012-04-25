# encoding: utf-8
require 'spec_helper'

describe Users::OmniauthCallbacksController do
  
  before(:each) do
    @user = FactoryGirl.create(:pipo)
    request.env["devise.mapping"] = Devise.mappings[:user] 
  end
  
  describe "GET twitter" do
    
    
    describe "after successful authorization from remote end" do
      
      before(:each) do
        request.env["omniauth.auth"] = mock_valid_auth_for(:twitter)
        Authorization.stub(:find_by_provider_and_uid) { FactoryGirl.create(:authorization, :user => @user) }
      end
      
      describe "if already registered" do
        
        it "should respond with a redirect" do
          get :twitter
          response.should be_redirect
        end
        
      end
      
      describe "if not registered yet" do
        
        before(:each) do
          Authorization.stub!(:find_by_provider_and_uid) { nil }
        end
        
        it "should assign the user to @user" do
          User.stub(:new_from_oauth_params) { @user }
          get :twitter
          assigns(:user).should == @user
        end 
        
        it "should render the twitter template" do
          User.stub(:new_from_oauth_params) { @user }
          get :twitter
          response.should render_template("twitter")
        end
        
      end
    end
    
    describe "after unsuccessful authorization from remote end" do
      
      before(:each) do
        request.env["omniauth.auth"] = nil
      end
      
      it "should render action failure" do
        get :twitter
        response.should render_template("failure")
      end
      
    end
    
  end
  
  describe "GET facebook" do
    
    describe "after successful authorization from remote end" do
      
      before(:each) do
        request.env["omniauth.auth"] = mock_valid_auth_for(:facebook)
      end
      
      describe "if already registered" do
        
        before(:each) do
          Authorization.stub!(:find_from_hash) { FactoryGirl.create(:authorization, :user => @user) }
        end
        
        it "should respond with a redirect" do
          get :facebook
          response.should be_redirect
        end
        
      end
      
      describe "if not registered yet" do
        
        before(:each) do
          Authorization.stub!(:find_from_hash) { nil }
        end
        
        it "should assign the user to @user" do
          User.stub(:new_from_oauth_params) { @user }
          get :facebook
          assigns(:user).should == @user
        end 
        
        it "should render the twitter template" do
          User.stub(:new_from_oauth_params) { @user }
          get :facebook
          response.should render_template("facebook")
        end
        
      end
    end
    
    describe "after unsuccessful authorization from remote end" do
      
      before(:each) do
        request.env["omniauth.auth"] = nil
      end
      
      it "should render action failure" do
        get :facebook
        response.should render_template("failure")
      end
      
    end
  end
  
  describe "POST create" do
    
    describe "with valid parameters" do
      
      before(:each) do
        #any would work here
        mock_in_session(:twitter)
        @user.stub!(:save) { true }
      end
      
      it "should change the count of authorizations for a user" do
        expect {
          post :create, :user => FactoryGirl.attributes_for(:someone)
        }.to change(Authorization, :count).by(1)
      end
      
      it "should assign user to @user" do
        post :create, :user => FactoryGirl.attributes_for(:someone)
        assigns(:user).should be_a(User)
      end
      
      it "should respond with a redirect" do
        post :create, :user => FactoryGirl.attributes_for(:someone)
        response.should be_redirect
      end
      
    end
    
    describe "with invalid parameters" do
      
      before(:each) do
        @user.stub!(:save) { false }
      end
      
      describe "for twitter" do
      
        before(:each) do
          mock_in_session(:twitter)
        end
      
        it "should assign user to @user" do
          post :create, :user => {:username => 'someone'}
          assigns(:user).should be_a(User)
        end
      
        it "should render the provider action" do
          post :create, :user => {:username => 'someone'}
          response.should render_template("twitter")
        end
      end
      
      describe "for facebook" do
      
        before(:each) do
          mock_in_session(:facebook)
        end
      
        it "should assign user to @user" do
          post :create, :user => {:username => 'someone'}
          assigns(:user).should be_a(User)
        end
        
        it "should render the provider action" do
          post :create, :user => {:username => 'someone'}
          response.should render_template("facebook")
        end
      end
    end
    
  end
  
  describe "If logged in" do
    
    before(:each) do
      sign_in @user
    end
    
    describe "with an authorization enabled" do

      before(:each) do        
        @authorization = FactoryGirl.create(:authorization, :user => @user)
      end

      it "can be deleted" do
        Authorization.should_receive(:find).with("1") { @authorization }
        delete :destroy, :id => "1"
        @authorization.should be_destroyed
      end

    end

    it "should add facebook" do
      lambda {
        request.env["omniauth.auth"] = mock_valid_auth_for(:facebook)
        get :facebook
      }.should change(Authorization, :count).by(1)
    end
    
    it "should add twitter" do
      lambda {
        request.env["omniauth.auth"] = mock_valid_auth_for(:twitter)
        get :twitter
      }.should change(Authorization, :count).by(1)
    end
    
  end
  
end

  def mock_in_session(provider)
    sess={:uid => "1", :token => "tkn", :secret => "sec"}
    session["devise.oauth_data"] = provider.eql?(:twitter) ? sess.merge(:provider => "twitter") : sess.merge(:provider => "facebook")
  end

  def mock_valid_auth_for(provider)
    { "provider" => "twitter", "uid" => "1", "credentials" => { "secret" => "sec", "token" => "tkn" } } if provider.eql?(:twitter)
    { "provider" => "facebook", "uid" => "1", "credentials" => { "token" => "tkn" } }
  end
