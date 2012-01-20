# encoding: utf-8
require 'spec_helper'

describe Places::ListingsController do    
  
  before(:each) do
    @categories = Category.all
    @places = []
  end
  
  it "should respond to index action when parameters NOT given" do
    Category.should_receive(:all).and_return(@categories)
    Place.should_receive(:order).and_return(@places)
    
    get :index
    
    assigns(:categories).should == @categories
    
    assigns(:places).should == @places
    response.should be_successful
  end
  
  it "should respond to index action when parameters given" do
    Category.should_not_receive(:all)
    Place.should_receive(:filtering_with).with("some-order", ["1","2"]).and_return(@places)
    
    get :index, :ordered_by => 'some-order', :categories => ["1","2"], :filtered => true
    
    assigns(:categories).should be_nil
    assigns(:places).should == @places
    response.should be_successful
  end
  
end