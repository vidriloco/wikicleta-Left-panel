# encoding: utf-8
require 'spec_helper'

describe ProfilesController do    
  
  before(:each) do
    @user = FactoryGirl.create(:pipo)
  end
  
  describe "GET find" do
    
    it "should find a user by it's username" do
      User.should_receive(:find_by_username).with("pepito") { @user }
      get :index, :username => "pepito"
      
      assigns(:user).should be(@user)
    end
    
    describe "for existent user profiles" do
      
      it "should render it's associated template" do
        User.stub(:find_by_username) { @user }
        get :index
      
        response.should render_template("index")
      end
      
    end
    
    describe "for inexistent user profiles" do
      
      it "should render an error template" do
        User.stub(:find_by_username) { nil }
        get :index
      
        response.should render_template("not_found")
      end
      
    end
  end
  
  describe "GET friends" do
    
    it "should find a user by it's username" do
      User.should_receive(:find_by_username).with("pepito") { @user }
      get :friends, :username => "pepito"
      
      assigns(:user).should be(@user)
    end
    
    describe "for existent user profiles" do
    
      it "should render it's associated template" do
        User.stub(:find_by_username) { @user }
        get :friends
      
        response.should render_template("friends")
      end
    
    end
    
    
    describe "for inexistent user profiles" do
      
      it "should render an error template" do
        User.stub(:find_by_username) { nil }
        get :friends
      
        response.should render_template("not_found")
      end
      
    end
  end
  
end