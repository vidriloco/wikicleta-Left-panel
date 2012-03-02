require "spec_helper"

describe IncidentsController do
  describe "routes" do
    
    it "matches /incidents/new with controller :incidents action #new" do
      { :get => "/incidents/new" }.should route_to(:action => "new", :controller => "incidents")
    end
    
    it "matches /incidents with controller :incidents action #create" do
      { :post => "/incidents" }.should route_to(:action => "create", :controller => "incidents")
    end
    
    it "matches /incidents with controller :incidents action #index" do
      { :get => "/incidents" }.should route_to(:action => "index", :controller => "incidents")
    end
    
    it "matches /incidents/filtering with controller :incidents action #post" do
      { :post => "/incidents/filtering" }.should route_to(:action => "filtering", :controller => "incidents")
    end
    
  end
end