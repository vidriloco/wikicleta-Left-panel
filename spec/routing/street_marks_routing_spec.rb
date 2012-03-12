require "spec_helper"

describe Map::StreetMarksController do
  describe "routes" do
    
    it "matches /map/street_marks with controller :street_marks action #index" do
      { :get => "/map/street_marks" }.should route_to(:action => "index", :controller => "map/street_marks")
    end
    
    it "matches /map/street_marks with controller :street_marks action #create" do
      { :post => "/map/street_marks" }.should route_to(:action => "create", :controller => "map/street_marks")
    end
    
    it "matches /map/street_marks/1 with controller :street_marks action #show" do
      { :get => "/map/street_marks/1" }.should route_to(:action => "show", :controller => "map/street_marks", :id => "1")
    end
    
  end
end