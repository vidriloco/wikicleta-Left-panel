require "spec_helper"

describe Places::EvaluationsController do
  describe "routes" do
    
    # For places
    it "matches /places/1/evaluations with controller :evaluations action #create" do
      { :post => '/places/1/evaluations' }.should route_to(:action => "create", :controller => "places/evaluations", :place_id => "1")
    end

    it "matches /places/1/evaluations/new with controller :evaluations action #new" do
      { :get => '/places/1/evaluations/new' }.should route_to(:action => "new", :controller => "places/evaluations", :place_id => "1")
    end
    
    it "matches /places/1/evaluations/edit/1 with controller :evaluations action #edit" do
      { :get => '/places/1/evaluations/edit/1' }.should route_to(:action => "edit", :controller => "places/evaluations", :place_id => "1", :id => "1")
    end
    
    it "matches /places/1/evaluations/1 with controller :evaluations action #update" do
      { :put => '/places/1/evaluations/1' }.should route_to(:action => "update", :controller => "places/evaluations", :place_id => "1", :id => "1")
    end
  end
  
end