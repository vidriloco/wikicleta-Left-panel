require "spec_helper"

describe Admins::MainController do
  
  describe "routing" do
    
    it "should match /admins" do
      { :get => "/admins" }.should route_to(:controller => "admins/main", :action => "index")
    end

  end
  
end