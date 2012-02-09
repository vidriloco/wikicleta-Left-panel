require "spec_helper"

describe Places::SearchesController do
  describe "routes" do
    
    it "matches /places/search with controller :search action #main" do
      { :get => "/places/search" }.should route_to(:action => "main", :controller => "places/searches")
    end
    
    it "matches /places/search with controller :search action #main_results" do
      { :post => "/places/search" }.should route_to(:action => "execute_main", :controller => "places/searches")
    end
    
  end
end