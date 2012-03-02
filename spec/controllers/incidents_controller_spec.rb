# encoding: utf-8
require 'spec_helper'

describe IncidentsController do    
  
  def valid_params
    Factory.attributes_for(:assault).inject({}){|memo,(k,v)| memo[k.to_s] = v.to_s; memo}
  end
  
  def coordinates
    {"lat" => "19.45", "lon" => "-99.23"}
  end
  
  describe "GET new" do
    
    it "should assign a new incident to @incident" do
      get :new
      assigns(:incident).should be_a_new(Incident)
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @incident = Factory.create(:assault)
    end
    
    it "should assign incident and apply geometry" do
      Incident.should_receive(:new_with).with(valid_params, coordinates, nil) { @incident }

      post :create, :incident => valid_params, :coordinates => coordinates
      assigns(:incident).should be(@incident)
    end
    
    describe "with logged-in user" do
      
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end
      
      it "should assing the reporting user to incident" do
        Incident.should_receive(:new_with).with(valid_params, coordinates, @user) { @incident }
        post :create, :incident => valid_params, :coordinates => coordinates
      end
      
    end
  
    describe "with valid parameters" do
  
      before(:each) do
        @incident.stub(:save).and_return(true)
      end

      it "redirects to the newly created incident" do
        Incident.stub(:new) { @incident }
        @incident.stub(:apply_geo)
  
        post :create
        response.should redirect_to(incidents_path)
      end
      
    end
  
    describe "with invalid parameters" do

      before(:each) do
        @incident.stub(:save).and_return(false)
      end

      it "renders action 'new'" do
        Incident.stub(:new) { @incident }
        post :create, :incident => {}, :coordinates => {}
        response.should render_template("new")
      end

    end
  end
  
  describe "GET index" do
    
    before(:each) do
      @incident = Factory.create(:assault)
    end
    
    it "should assign the incident ocurrence" do
      get :index
      assigns(:incidents).should == {@incident.kind => [@incident], "total" => 1}
    end
    
  end
  
  describe "POST filtering" do
    
    before(:each) do
      @incident = Factory.create(:assault)
      @incidents = {@incident.kind => [@incident], "total" => 1}
    end
    
    it "should receive the parameters for the search" do
      Incident.should_receive(:filtering_with).and_return(@incidents)
      post :filtering, :incident => {}
      
      assigns(:incidents).should == @incidents
    end
    
  end
  
end
