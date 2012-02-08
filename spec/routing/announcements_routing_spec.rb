require "spec_helper"

describe Places::AnnouncementsController do
  
  describe "routes" do

    it "matches /places/1/announcements with controller :announcements action #index" do
      { :get => "/places/1/announcements" }.should route_to(:action => "index", :controller => "places/announcements", :place_id => "1")
    end
    
    it "matches /places/1/announcements with controller :announcements action #destroy" do
      { :delete => "/places/1/announcements/2" }.should route_to(:action => "destroy", :controller => "places/announcements", :place_id => "1", :id => "2")
    end
    
    it "matches /places/1/announcements with controller :announcements action #create" do
      { :post => "/places/1/announcements" }.should route_to(:action => "create", :controller => "places/announcements", :place_id => "1")
    end
    
  end
end