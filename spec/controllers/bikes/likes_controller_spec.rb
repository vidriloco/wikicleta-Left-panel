# encoding: utf-8
require 'spec_helper'

describe Bikes::LikesController do   
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    
    @bike = Bike.new
  end
  
  describe "POST create" do
    
    it "should create a new like from a user to a bike" do
      Bike.should_receive(:find).with("1") { @bike }
      @bike.should_receive(:register_like_from).with(@user)
      
      post :create, :id => "1"
      assigns(:bike).should be(@bike)
    end

  end
  
  describe "DELETE destroy" do
    
    it "should destroy an existent like from a user to a bike" do
      Bike.should_receive(:find).with("1") { @bike }
      @bike.should_receive(:destroy_like_from).with(@user)
      
      delete :destroy, :id => "1"
    end
    
  end
  
end