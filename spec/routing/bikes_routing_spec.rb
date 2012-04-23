require "spec_helper"

describe "Bikes routing" do

  it "matches /bikes with controller action #index on bikes" do
    { :get => "/bikes" }.should route_to(:action=>"index", :controller=>"bikes")
  end
  
  it "matches /bikes/1/like with controller action #create on bikes/likes" do
    { :post => "/bikes/1/like" }.should route_to(:action => "create", :controller => "bikes/likes", :id => "1")
  end
  
  it "matches /bikes/1/like with controller action #delete on bikes/likes" do
    { :delete => "/bikes/1/like" }.should route_to(:action => "destroy", :controller => "bikes/likes", :id => "1")
  end
  
  it "matches /bikes/1/bike_statuses with controller action #create on bikes/statuses" do
    { :post => "/bikes/1/bike_statuses" }.should route_to(:action => "create", :controller => "bikes/statuses", :bike_id => "1")
  end
  
  it "matches /bikes/1/bike_statuses/2 with controller action #update on bikes/statuses" do
    { :put => "/bikes/1/bike_statuses/2" }.should route_to(:action => "update", :controller => "bikes/statuses", :bike_id => "1", :id => "2")
  end
  
  it "matches /bikes/1/pictures with controller action #create on pictures" do
    { :post => "/bikes/1/pictures" }.should route_to(:action => "create", :controller => "pictures", :bike_id => "1")
  end

end