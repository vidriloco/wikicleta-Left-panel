# encoding: utf-8
require 'spec_helper'

describe Places::EvaluationsController do    
  
  describe "GET new" do
    
    before(:each) do
      @place = Place.new
    end
    
    describe "if logged-in" do
      
      before(:each) do
        sign_in(Factory(:user))
      end
    
      it "should find the place whose evaluation form has to be rendered" do
        Place.should_receive(:find).with("1") { @place }
      
        get :new, :place_id => "1"
        assigns(:place).should == @place
      end   
      
      it "should respond with a success" do
        Place.stub(:find) { @place }
        get :new, :place_id => "1"
        response.body.should_not be_empty
      end
      
    end
    
    describe "if NOT logged-in" do
      
      it "should render an unsuccessful response" do      
        get :new, :place_id => "1"
        response.should_not be_success
      end
      
    end 
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @survey = Survey.new
      @place = Place.new
    end
    
    describe "if logged-in" do
      before(:each) do
        @user = Factory(:user)
        sign_in(@user)
      end
      
      it "should assign the new survey to @survey" do
        Place.should_receive(:find).with("1").and_return(@place)
        
        Survey.should_receive(:from_hash).with({'a' => 'hash', "user" => @user, "evaluable" => @place}).and_return(@survey)
        post :create, :place_id => "1", :survey => {'a' => 'hash'}
      end
    end
    
    
    describe "if NOT logged-in" do
      
      it "should render an unsuccessful response" do      
        get :create, :place_id => "1", :survey => {'a' => 'hash'}
        response.should_not be_success
      end
      
    end
  end
end