require "spec_helper"

describe "User profiles routing" do
  describe "routes" do
    it "matches /profile/monstruo with controller action #index on profiles" do
      { :get => "/profile/monstruo" }.should route_to(:action=>"index", :controller=>"profiles", :username => "monstruo")
    end
    
    it "matches /profile/monstruo/friends with controller action #friends on profiles" do
      { :get => "/profile/monstruo/friends" }.should route_to(:action => "friends", :controller => "profiles", :username => "monstruo")
    end
  end
end