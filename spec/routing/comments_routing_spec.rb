require "spec_helper"

describe Places::CommentsController do
  
  describe "routes" do
    
    it "matches /places/1/comments with controller :comments action #index" do
      { :get => "/places/1/comments" }.should route_to(:action => "index", :controller => "places/comments", :place_id => "1")
    end
    
    it "matches /places/1/comments with controller :comments action #create" do
      { :post => "/places/1/comments" }.should route_to(:action => "create", :controller => "places/comments", :place_id => "1")
    end
    
    it "matches /places/1/comments with controller :comments action #destroy" do
      { :delete => "/places/1/comments/2" }.should route_to(:action => "destroy", :controller => "places/comments", :place_id => "1", :id => "2")
    end
    
  end
end