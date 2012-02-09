require "spec_helper"

describe "Places routing" do
  describe "routes" do
    it "matches /places with controller :listings action #index" do
      { :get => "/places" }.should route_to(:action=>"index", :controller=>"places")
    end
    
    it "matches /places/new with controller :commits action #new" do
      { :get => "/places/new"}.should route_to(:action => "new", :controller => "places")
    end
    
    it "matches /places with controller :commits action #create" do
      { :post => "/places"}.should route_to(:action => "create", :controller => "places")
    end
    
    it "matches /places/1 with controller :representations action #show" do
      { :get => "/places/1"}.should route_to(:action => "show", :controller => "places", :id => "1")
    end
    
    it "matches /places/edit/1 with controller :commits action #edit" do
      { :get => "/places/edit/1"}.should route_to(:action => "edit", :controller => "places", :id => "1")
    end
    
    it "matches /places with controller :commits action #update" do
      { :put => "/places/1"}.should route_to(:action => "update", :controller => "places", :id => "1")
    end
    
  end
end