# encoding: utf-8
require 'spec_helper'

describe SettingsController do    
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  
  describe "GET account" do

    it "sets a user record to @user" do
      get :account
      
      assigns(:user).should == @user
      response.should be_successful
    end

  end
  
  describe "GET access" do
    
    it "sets a user record to @user" do
      get :access
      
      assigns(:user).should == @user
      response.should be_successful
    end
    
  end
  
  describe "GET profile" do
    
    it "sets a user record to @user" do
      get :profile
      
      assigns(:user).should == @user
      response.should be_successful
    end
    
  end
  
  describe "PUT changed" do
    
    it "updates user and sets it to @user" do
      params= { 'email' => 'someone@example.com' }
      
      @user.stub(:update_attributes).with(params).and_return(true)
      put :changed, :user => params
      
      assigns(:user).should == @user
      flash[:notice].should eql(I18n.t("user_accounts.settings.successful_save"))
    end
    
    it "does not updates user but it also sets it to @user" do
      params = { 'password' => 'p', 'password_confirmation' => 'pd' }
      
      @user.stub(:update_attributes).with(params).and_return(false)
      put :changed, :user => params
      
      assigns(:user).should == @user
      flash[:notice].should eql(I18n.t("user_accounts.settings.unsuccessful_save"))
    end
    
    it "always renders a successful response" do
      response.should be_successful
    end
    
  end
  
  
end
