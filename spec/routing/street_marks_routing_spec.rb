require "spec_helper"

describe Map::StreetMarksController do
  describe "routes" do
    
    it "matches /map/street_marks with controller :street_marks action #index" do
      { :get => "/map/street_marks" }.should route_to(:action => "index", :controller => "map/street_marks")
    end
    
  end
end