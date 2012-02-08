# encoding: utf-8
require 'spec_helper'

describe Places::RecommendationsController do   
  
  before(:each) do
    @user = Factory(:user)
    sign_in @user
    
    @place = Place.new
  end
  
  describe "PUT update" do

    it "should change the recommendation status of a user respect a given place" do
      Place.should_receive(:find).with("1") { @place }
      @place.should_receive(:change_recommendation_status_for).with(@user, "on")
      
      put :update, :place_id => "1", :recommend => :on
      
      assigns(:place).should be(@place)
    end
  end
  
  describe "GET index" do
    
    it "should fetch all the recommendations for a given place" do
      Place.should_receive(:include_with).with("1", :recommendations) { @place }
      get :index, :place_id => "1"
      assigns(:place).should == @place
    end
    
  end
  
end