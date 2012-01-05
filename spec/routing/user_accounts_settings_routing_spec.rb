require "spec_helper"

describe "User accounts settings routing" do

  it "matches /settings/account with controller action #account on settings" do
    { :get => "/settings/account" }.should route_to(:action=>"account", :controller=>"settings")
  end
    
  it "matches /settings/profile with controller action #profile on settings" do
    { :get => "/settings/profile" }.should route_to(:action=>"profile", :controller=>"settings")
  end
    
  it "matches /settings/access with controller action #access on settings" do
    { :get => "/settings/access" }.should route_to(:action=>"access", :controller=>"settings")
  end
  
  it "matches /settings/changed with controller action #changed on settings" do
    { :put => "/settings/changed" }.should route_to(:action => "changed", :controller=>"settings")
  end

end