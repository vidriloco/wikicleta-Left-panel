# encoding: utf-8
require 'spec_helper'

describe Users::OmniauthCallbacksController do
  
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user] 
  end
  
  describe "GET twitter" do
    
    before(:each) do
      @user = Factory.create(:user)
    end
    
    describe "after successful authorization from remote end" do
      
      before(:each) do
        request.env["omniauth.auth"] = mock_valid_auth_for(:twitter)
        Authorization.stub(:find_by_provider_and_uid) { Factory(:authorization, :user_id => @user.id) }
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
    
    before(:each) do
      @user = Factory.create(:user)
    end
    
    describe "after successful authorization from remote end" do
      
      before(:each) do
        request.env["omniauth.auth"] = mock_valid_auth_for(:facebook)
        Authorization.stub(:find_by_provider_and_uid) { Factory(:authorization, :user_id => @user.id) }
      end
      
      describe "if already registered" do
        
        it "should respond with a redirect" do
          get :facebook
          response.should be_redirect
        end
        
      end
      
      describe "if not registered yet" do
        
        before(:each) do
          Authorization.stub!(:find_by_provider_and_uid) { nil }
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
    
    before(:each) do
      @user = Factory.stub(:someone)
    end
    
    describe "with valid parameters" do
      
      before(:each) do
        #any would work here
        mock_in_session(:twitter)
        @user.stub!(:save) { true }
      end
      
      it "should change the count of authorizations for a user" do
        expect {
          post :create, :user => Factory.attributes_for(:someone)
        }.to change(Authorization, :count).by(1)
      end
      
      it "should assign user to @user and persist it" do
        post :create, :user => Factory.attributes_for(:someone)
        assigns(:user).should be_a(User)
        @user.should be_persisted
      end
      
      it "should respond with a redirect" do
        post :create, :user => Factory.attributes_for(:someone)
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
          post :create, :user => {}
          assigns(:user).should be_a(User)
        end
      
        it "should render the provider action" do
          post :create, :user => {}
          response.should render_template("twitter")
        end
      end
      
      describe "for facebook" do
      
        before(:each) do
          mock_in_session(:facebook)
        end
      
        it "should assign user to @user" do
          post :create, :user => {}
          assigns(:user).should be_a(User)
        end
        
        it "should render the provider action" do
          post :create, :user => {}
          response.should render_template("facebook")
        end
      end
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
