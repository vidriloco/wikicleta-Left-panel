require "spec_helper"

describe Map::IncidentsController do
  describe "routes" do
    
    it "matches /map/incidents with controller :incidents action #index" do
      { :get => "/map/incidents" }.should route_to(:action => "index", :controller => "map/incidents")
    end
    
    it "matches /map/incidents/new with controller :incidents action #new" do
      { :get => "/map/incidents/new" }.should route_to(:action => "new", :controller => "map/incidents")
    end
    
    it "matches /map/incidents with controller :incidents action #create" do
      { :post => "/map/incidents" }.should route_to(:action => "create", :controller => "map/incidents")
    end
    
    it "matches /map/incidents/1 with controller :incidents action #index" do
      { :get => "/map/incidents/1" }.should route_to(:action => "show", :controller => "map/incidents", :id => "1")
    end
    
    it "matches /map/incidents/filtering with controller :incidents action #post" do
      { :get => "/map/incidents/filtering" }.should route_to(:action => "filtering", :controller => "map/incidents")
    end
    
  end
end