require "spec_helper"

describe Places::RecommendationsController do
  
  describe "routes" do
    
    it "matches /places/1/recommendations with controller :recommendations action #index" do
      { :get => "/places/1/recommendations" }.should route_to(:action => "index", :controller => "places/recommendations", :place_id => "1")
    end
  
    it "matches /places/1/recommendations/on with controller :recommendations action #follow" do
      { :put => "places/1/recommendations/on" }.should route_to(:action => "update", :controller => "places/recommendations", :place_id => "1", :recommend => "on")
    end
  
    it "matches /places/1/recommendations/off with controller :recommendations action #follow" do
      { :put => "places/1/recommendations/off" }.should route_to(:action => "update", :controller => "places/recommendations", :place_id => "1", :recommend => "off")
    end
    
  end
end