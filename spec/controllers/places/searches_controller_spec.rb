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
      response.should render_template("main_results")
    end
  
  end
  
end