# encoding: utf-8
require 'spec_helper'

describe Places::SearchesController do    
  
  before(:each) do
    @places = []
  end
  
  describe "POST execute_main" do
    
    it "should execute a search with the given parameters and assign the results to @places" do
      Place.should_receive(:find_by).with({'place' => { 'some' => 'params' }}) { @places }
      post :execute_main, :search => { :place => { 'some' => 'params' } }
    
      assigns(:places).should == @places
    end
    
    it "should render the main results template" do
      Place.should_receive(:find_by)
      post :execute_main
      
      assigns(:search_mode).should be(true)
      response.should render_template("index")
    end
  
  end
  
  describe "GET main" do
    
    before(:each) do
      @categories = []
    end
    
    it "should fetch the places categories" do
      Category.should_receive(:all).and_return(@categories)
      get :main
      response.should be_success
    end
    
  end
  
end