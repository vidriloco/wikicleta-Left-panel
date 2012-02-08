# encoding: utf-8
require 'spec_helper'

describe Places::CommentsController do    
  
  before(:each) do
    @place = Place.new
  end
  
  describe "POST create" do
    
    describe "if logged-in" do
    
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end
    
      it "should receive some params and register a new comment" do
        Place.should_receive(:find).with("1") { @place }
        @place.should_receive(:add_comment).with(@user, "One comment")
      
        post :create, :place_id => "1", :place_comment => {:content => "One comment"}
        assigns(:place).should be(@place)
      end
    
    end
    
    describe "if NOT logged-in" do
      
      it "should render an unsuccessful response" do
        post :create, :place_id => "1"
        response.should_not be_success
      end
      
    end
    
  end
        
  describe "DELETE destroy" do
    
    before(:each) do
      @comment = PlaceComment.new
    end
    
    describe "if logged-in" do
    
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end
      
      describe "when logged-in user is the comment owner" do
      
        before(:each) do
          @comment.stub(:owned_by?) { true }
        end
      
        it "should succeed on deleting the comment" do
          PlaceComment.should_receive(:find).with("1") { @comment }
          @comment.should_receive(:destroy).and_return(true)
      
          delete :destroy, :place_id => "2", :id => "1"
      
          assigns(:place_comment_destroyed).should be_true
        end
      end
    
      describe "when logged-in user is the comment owner" do
      
        before(:each) do
          @comment.stub(:owned_by?) { false }
        end
      
        it "should NOT succeed on deleting the comment and render an empty response" do
          PlaceComment.should_receive(:find).with("1") { @comment }
          @comment.should_not_receive(:destroy)
        
          delete :destroy, :place_id => "2", :id => "1"
        
          response.body.should be_blank
        end
      
      end
    end
    
    describe "if NOT logged-in" do
      
      it "should render an unsuccessful response" do
        post :destroy, :place_id => "2", :id => "1"
        response.should_not be_success
      end
      
    end
    
  end
  
  describe "GET index" do
    
    it "should fetch all the comments from a given place" do
      Place.should_receive(:include_with).with("1", :commenters) { @place }
      get :index, :place_id => "1"
      assigns(:place).should == @place
    end
    
  end
  
end