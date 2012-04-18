# encoding: utf-8
require 'spec_helper'

describe Bikes::StatusesController do   
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    
    @bike_status = FactoryGirl.create(:bike_share, :bike => FactoryGirl.create(:bike))
  end
  
  describe "POST create" do
    
    it "should register a new bike status for a given bike" do
      params = {'some' => 'params'}
      BikeStatus.should_receive(:create_with_bike).with("1", params) { @bike_status }
      
      post :create, :bike_id => "1", :bike_status => params
      assigns(:bike_status).should be(@bike_status)
    end

  end
  
  describe "PUT update" do
    
    it "should update an existant bike status for a given bike" do
      
      params = {'some' => 'params'}
      BikeStatus.should_receive(:update_with).with("1", params) { @bike_status }
      
      put :update, :bike_id => "2", :bike_status => params, :id => "1"
      assigns(:bike_status).should be(@bike_status)
      
    end
    
  end
  
end