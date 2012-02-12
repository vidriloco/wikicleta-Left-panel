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
      
      it "should assign the new evaluation to @survey" do
        Place.should_receive(:find).with("1").and_return(@place)
        
        Survey.should_receive(:from_hash).with({'questions' => {}, 'meta_survey_id' => '1', "user" => @user, "evaluable" => @place}).and_return(@survey)
        post :create, :place_id => "1", :survey => {'questions' => {}, 'meta_survey_id' => '1'}
      end
      
      it "should respond with a success" do
        Place.stub(:find) { @place }
        Survey.stub(:from_hash) { @survey }
        post :create, :place_id => "1", :survey => {}
        response.body.should_not be_empty
      end
    end
    
    
    describe "if NOT logged-in" do
      
      it "should render an unsuccessful response" do      
        get :create, :place_id => "1", :survey => {'a' => 'hash'}
        response.should_not be_success
      end
      
    end
  end
  
  describe "GET edit" do
    
    before(:each) do
      @survey = Survey.new
      @place = Place.new
    end
    
    describe "if logged-in" do
      
      before(:each) do
        @user = Factory(:user)
        sign_in(@user)
      end
      
      it "should find and assign an existing evaluation to @survey" do
        Survey.should_receive(:find).with("1").and_return(@survey)
        @survey.should_receive(:evaluable).and_return(@place)
        get :edit, :id => "1", :place_id => "3"
        
        assigns(:place).should == @place
        assigns(:survey).should == @survey
      end
      
    end
    
    describe "if not logged-in" do
      
      it "should render an unsuccessful response" do      
        get :edit, :id => "1", :place_id => "3"
        response.should_not be_success
      end
      
    end
  end
  
  describe "PUT update" do
    
    before(:each) do
      @survey = Survey.new
      @place = Place.new
    end
    
    describe "if logged-in" do
      
      before(:each) do
        @user = Factory(:user)
        sign_in(@user)
      end
      
      it "should find the place this evaluation is assigned to and assign it" do
        Place.should_receive(:find).with("3").and_return(@place)
        
        Survey.stub(:find) { @survey }
        Survey.stub(:from_hash) { @survey }
        
        put :update, :id => "1", :place_id => "3", :survey => { }
        assigns(:place).should == @place
      end
      
      it "should build the new evaluation from the parameters hash" do
        Place.stub(:find) { @place }
        Survey.stub(:find) { @survey }
      
        Survey.should_receive(:from_hash).with({'questions' => {}, 'meta_survey_id' => '1', "user" => @user, "evaluable" => @place}).and_return(@survey)
        put :update, :id => "1", :place_id => "3", :survey => {'questions' => {}, 'meta_survey_id' => '1'}
      end
      
      describe "with successful save" do
        
        before(:each) do
          @survey.stub(:save) { true }
        end
        
        it "should find and delete the existent evaluation" do
          Place.stub(:find) { @place }
          Survey.stub(:from_hash) { @survey }
          
          Survey.should_receive(:find).with("1").and_return(@survey)
          @survey.should_receive(:destroy)
        
          put :update, :id => "1", :place_id => "3", :survey => { }
        end
      
      end
      
      describe "with unsuccessful save" do
        
        before(:each) do
          @survey.stub(:save) { false }
        end
        
        it "should NOT attempt to find neither delete the existent evaluation" do
          Place.stub(:find) { @place }
          Survey.stub(:from_hash) { @survey }
          
          Survey.should_not_receive(:find)
          @survey.should_not_receive(:destroy)
      
          put :update, :id => "1", :place_id => "3", :survey => { }
        end
      
      end
      
      it "should respond with success" do
        Place.stub(:find) { @place }
        Survey.stub(:find) { @survey }
        Survey.stub(:from_hash) { @survey }
      
        put :update, :id => "1", :place_id => "3", :survey => {}
        response.body.should_not be_empty
      end
      
    end
    
    describe "if not logged-in" do
      
      it "should render an unsuccessful response" do      
        put :update, :id => "1", :place_id => "3", :survey => {}
        response.should_not be_success
      end
      
    end
  end
end