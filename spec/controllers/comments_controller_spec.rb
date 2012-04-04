# encoding: utf-8
require 'spec_helper'

describe CommentsController do
  
  before(:each) do
    @user = FactoryGirl.create(:pipo)
  end
  
  describe "POST create" do
    
    def params
      {"commentable_id" => "1", "commentable_type" => "Bike", "comment" => "a comment", "user_id" => @user.id}
    end
    
    describe "if logged-in" do
    
      before(:each) do
        sign_in @user
        @comment = FactoryGirl.create(:comment_for_bike, :user => @user)
      end
    
      it "should initialize a new comment and assign it" do
        Comment.should_receive(:new).with(params) { @comment }
      
        post :create, :comment => params
        assigns(:comment).should == @comment
      end
      
      it "should persist a new comment" do
        Comment.stub(:new).with(params) { @comment }
        
        post :create, :comment => params
        
        @comment.should be_persisted
      end
    
    end
    
    describe "if NOT logged-in" do
      
      it "should render an unsuccessful response" do
        post :create, :comment => {}
        response.should_not be_success
      end
      
    end
    
  end
  
  describe "DELETE destroy: " do
    
    before(:each) do
      @comment = FactoryGirl.create(:comment_for_bike, :user => @user)
    end
    
    describe "If I am logged-in it" do
    
      before(:each) do
        sign_in @user
      end
            
     it "should find the requested comment" do
        Comment.should_receive(:find_by_id_and_user_id).with("1", @user.id) { @comment }
        delete :destroy, :id => 1
      end
      
      it "should assign the comment to @comment and delete it" do
        Comment.stub(:find_by_id_and_user_id) { @comment }
        @comment.should_receive(:destroy)
        delete :destroy, :id => 1
        
        assigns(:comment).should == @comment
      end

    end
    
    describe "If I am NOT logged-in" do
      
      it "should render an unsuccessful response" do
        delete :destroy, :id => "1"
        response.should_not be_success
      end
      
    end
    
  end
  
end