# encoding: utf-8
require 'spec_helper'

describe Places::AnnouncementsController do    
  
  before(:each) do
    @place = Place.new
  end
  
  describe "GET index" do
    
    it "should fetch all the announcements for a given place" do
      Place.should_receive(:include_with).with("1", :announcements) { @place }
      get :index, :place_id => "1"
      assigns(:place).should == @place
    end
    
  end
  
  describe "if NOT signed-in" do
    
    describe "POST create" do
      
      it "should render an unsuccessful response" do
        post :create, :place_id => "1", :announcement => {}
        response.should_not be_success
      end
      
    end
    
    describe "DELETE destroy" do
      
      it "should render an unsuccessful response" do
        delete :destroy, :place_id => "1", :id => "2", :announcement => {}
        response.should_not be_success
      end
      
    end
    
  end
  
  describe "if signed-in" do
  
    before(:each) do
      @user = Factory(:user)
      sign_in(@user)
    end
  
    describe "POST create" do
    
      before(:each) do
        @announcement = Announcement.new
      end
    
      describe "when logged-in user is owner and is verified" do
  
        before(:each) do
          @place.stub(:add_announcement) { true }
        end
  
        it "should succeed on posting an announcement" do 
          Place.should_receive(:find).with("1") { @place }
    
          post :create, :place_id => "1", :announcement => { :header => "some header", :message => "a message" }
          assigns(:announcement).should be_true
        end
      
      end
    
      describe "when logged-in user is NOT a verified owner" do
      
        before(:each) do
          @place.stub(:add_announcement) { false }
        end
      
        it "should fail on posting an announcement and respond with an empty response" do 
          Place.should_receive(:find).with("1") { @place }
    
          post :create, :place_id => "1"
        
          response.body.should be_blank
        end
      
      end 
    
    end
     
    describe "DELETE destroy" do
    
      before(:each) do
        @announcement = Announcement.new
        @announcement.stub(:place) { @place }
      end
    
      describe "when logged-in user is owner and is verified" do
  
        before(:each) do
          @place.stub(:verified_owner_is?) { true }
        end
  
        it "should succeed on deleting an announcement" do 
          Announcement.should_receive(:find).with("1") { @announcement }
          @announcement.should_receive(:destroy) { true }
    
          delete :destroy, :place_id => "2", :id => "1"
          assigns(:announcement_destroyed).should be_true
        end
      
      end  
      
      describe "when logged-in user is NOT a verified owner" do
    
        before(:each) do
          @place.stub(:verified_owner_is?) { false }
        end
    
        it "should NOT succeed on deleting an announcement and render an empty response" do
          Announcement.should_receive(:find).with("1") { @announcement }
        
          delete :destroy, :id => "1", :place_id => "2"
        
          response.body.should be_blank
        end
      
      end
    end
  
  end
  
end