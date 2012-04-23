require "spec_helper"

describe "Pictures routing" do
  describe "routes" do
    
    it "matches /pictures/1/set_main with controller pictures action #set_main" do
      { :put => "/pictures/1/set_main" }.should route_to(:action => "set_main", :controller => "pictures", :id => "1")
    end
    
    it "matches /pictures/1/change_caption with controller pictures action #change_caption" do
      { :put => "/pictures/1/change_caption" }.should route_to(:action => "change_caption", :controller => "pictures", :id => "1")
    end
        
  end
end