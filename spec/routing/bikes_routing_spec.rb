require "spec_helper"

describe "Bikes routing" do

  it "matches /bikes with controller action #index on bikes" do
    { :get => "/bikes" }.should route_to(:action=>"index", :controller=>"bikes")
  end
  
  it "matches /bikes/1/like with controller action #create on bikes" do
    { :post => "/bikes/1/like" }.should route_to(:action => "create", :controller => "bikes/likes", :id => "1")
  end
  
  it "matches /bikes/1/like with controller action #delete on bikes" do
    { :delete => "/bikes/1/like" }.should route_to(:action => "delete", :controller => "bikes/likes", :id => "1")
  end

end