require 'spec_helper'

describe Admins::MainController do

  describe "GET index" do
  
    before(:each) do
      @admin = Factory(:admin)
    end
    
    it "should respond with a redirect if I am NOT logged-in" do
      get :index
      response.should be_redirect 
    end
     
    describe "if I am logged-in" do
  
      before(:each) do
        sign_in @admin
      end
  
      it "should set the current manager" do
        get :index 
        assigns(:admin).should == @admin
      end
      
      it "should respond with a success" do
        get :index 
        response.should be_success
      end
    end
  
  end
  
end