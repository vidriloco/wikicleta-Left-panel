# encoding: utf-8
require 'spec_helper'

describe Map::IncidentsController do    
  
  before(:each) do
    @user = FactoryGirl.create(:pipo)
  end
  
  def valid_params
    { 'valid' => 'params' }
  end
  
  def coordinates
    {"lat" => "19.45", "lon" => "-99.23"}
  end
  
  describe "POST create" do
    
    before(:each) do
      @incident = FactoryGirl.create(:assault, :user => @user)
    end
    
    it "should assign incident and apply geometry" do
      Incident.should_receive(:new_with).with(valid_params, coordinates, nil) { @incident }

      post :create, :incident => valid_params, :coordinates => coordinates
      assigns(:incident).should be(@incident)
    end
    
    describe "with logged-in user" do
      
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      
      it "should assing the reporting user to incident" do
        Incident.should_receive(:new_with).with(valid_params, coordinates, @user) { @incident }
        post :create, :incident => valid_params, :coordinates => coordinates
      end
      
    end
  end
  
  describe "GET index" do
    
    context "html rendering" do
      
      before(:each) do
        @incident = Incident.new
      end
            
      it "assigns new instance" do
        Incident.should_receive(:new).and_return(@incident)
        get :index
        assigns(:incident).should == @incident
      end
      
    end
    
    context "js rendering" do
      
      before(:each) do
        @incidents = {}
      end
      
      it "assigns grouped incidents" do
        Incident.should_receive(:categorized_by_kinds).and_return(@incidents)
        get :index, :format => :js
        assigns(:incidents).should == @incidents
      end
      
    end
    
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      @incident = FactoryGirl.create(:assault, :user => @user)
    end
    
    it "destroys the requested incident" do
      expect {
        delete :destroy, :id => @incident.id
      }.to change(Incident, :count).by(-1)
    end
    
  end
  
  describe "GET filtering" do
    
    before(:each) do
      @incident = FactoryGirl.create(:assault, :user => @user)
      @incidents = {@incident.kind => [@incident], "total" => 1}
    end
    
    it "should receive the parameters for the search" do
      Incident.should_receive(:filtering_with) { @incidents }
      get :filtering, :incident => {}
      
      assigns(:incidents).should == @incidents
    end
    
  end
  
  describe "GET show" do
    
    before(:each) do
      @incident = FactoryGirl.create(:assault, :user => @user)
    end
    
    it "should assign the requested incident" do
      Incident.should_receive(:find).with("1") { @incident }
      get :show, :id => "1"
      assigns(:incident).should == @incident
    end
    
  end
  
end
