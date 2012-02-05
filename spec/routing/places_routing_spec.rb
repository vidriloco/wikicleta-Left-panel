require "spec_helper"

describe "Places routing" do
  describe "routes" do
    it "matches /places with controller :listings action #index" do
      { :get => "/places" }.should route_to(:action=>"index", :controller=>"places/listings")
    end
    
    it "matches /places/new with controller :commits action #new" do
      { :get => "/places/new"}.should route_to(:action => "new", :controller => "places/commits")
    end
    
    it "matches /places with controller :commits action #create" do
      { :post => "/places"}.should route_to(:action => "create", :controller => "places/commits")
    end
    
    it "matches /places/1 with controller :representations action #show" do
      { :get => "/places/1"}.should route_to(:action => "show", :controller => "places/representations", :id => "1")
    end
    
    it "matches /places/edit/1 with controller :commits action #edit" do
      { :get => "/places/edit/1"}.should route_to(:action => "edit", :controller => "places/commits", :id => "1")
    end
    
    it "matches /places with controller :commits action #update" do
      { :put => "/places/1"}.should route_to(:action => "update", :controller => "places/commits", :id => "1")
    end
    
    #search
    
    it "matches /places/search with controller :search action #main" do
      { :get => "/places/search" }.should route_to(:action => "main", :controller => "places/searches")
    end
    
    it "matches /places/search with controller :search action #main_results" do
      { :post => "/places/search" }.should route_to(:action => "execute_main", :controller => "places/searches")
    end
    
    # Announcements
    
    it "matches /places/1/announcements with controller :representations action #announcements" do
      { :get => "/places/1/announcements" }.should route_to(:action => "announcements", :controller => "places/representations", :id => "1")
    end
    
    it "matches /places/1/announcements with controller :commits action #unannounce" do
      { :delete => "/places/1/announcements" }.should route_to(:action => "unannounce", :controller => "places/commits", :id => "1")
    end
    
    it "matches /places/1/announcements with controller :commits action #announce" do
      { :post => "/places/1/announcements" }.should route_to(:action => "announce", :controller => "places/commits", :place_id => "1")
    end
    
    # Followers
    
    it "matches /places/1/followers with controller :representations action #followers" do
      { :get => "/places/1/followers" }.should route_to(:action => "followers", :controller => "places/representations", :id => "1")
    end
    
    it "matches /places/1/follow/on with controller :commits action #follow" do
      { :put => "places/1/follow/on" }.should route_to(:action => "follow", :controller => "places/commits", :id => "1", :follow => "on")
    end
    
    it "matches /places/1/follow/off with controller :commits action #follow" do
      { :put => "places/1/follow/off" }.should route_to(:action => "follow", :controller => "places/commits", :id => "1", :follow => "off")
    end
    
    # Comments
    
    it "matches /places/1/comments with controller :representations action #comments" do
      { :get => "/places/1/comments" }.should route_to(:action => "comments", :controller => "places/representations", :id => "1")
    end
    
    it "matches /places/1/comments with controller :commits action #comments" do
      { :post => "/places/1/comments" }.should route_to(:action => "comment", :controller => "places/commits", :id => "1")
    end
    
    it "matches /places/1/comments with controller :commits action #uncomment" do
      { :delete => "/places/1/comments" }.should route_to(:action => "uncomment", :controller => "places/commits", :id => "1")
    end
    
  end
end