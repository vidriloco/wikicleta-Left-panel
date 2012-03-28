require "spec_helper"

describe "Bikes routing" do

  it "matches /bikes with controller action #index on bikes" do
    { :get => "/bikes" }.should route_to(:action=>"index", :controller=>"bikes")
  end

end