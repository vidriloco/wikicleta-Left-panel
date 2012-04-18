require 'spec_helper'

describe BikeStatus do
  
  before(:each) do
    @bike = FactoryGirl.create(:bike)
  end
  
  describe "Given I have two stored bike status for my bike" do
  
    before(:each) do
      @bike_rent = FactoryGirl.create(:bike_rent, :bike => @bike)
      @bike_share = FactoryGirl.create(:bike_share, :bike => @bike)
    end
    
    it "should generate a hash including those two and a new one" do
      BikeStatus.find_all_for_bike(@bike)[:share].should == @bike_share
      BikeStatus.find_all_for_bike(@bike)[:rent].should == @bike_rent
      
      BikeStatus.find_all_for_bike(@bike).should have_key(:sell)
      BikeStatus.find_all_for_bike(@bike)[:sell].should be_instance_of(BikeStatus)
      BikeStatus.find_all_for_bike(@bike)[:sell].should_not be_persisted
    end
    
    it "should let me update the attributes for my bike share status" do
      bike_status = BikeStatus.update_with(@bike_share.id, {availability: "1", concept: Bike.category_for(:statuses, :share), only_friends: "1"})
      bike_status.availability.should be_true
      bike_status.concept.should == Bike.category_for(:statuses, :share)
      bike_status.only_friends.should be_true
    end
    
    it "should let me update the attributes for my bike rent status" do
      bike_status = BikeStatus.update_with(@bike_rent.id, {availability: "1", concept: Bike.category_for(:statuses, :rent), hour_cost: "40", day_cost: "20", month_cost: "56.3" })
      bike_status.availability.should be_true
      bike_status.concept.should == Bike.category_for(:statuses, :rent)
      bike_status.hour_cost.should == 40
      bike_status.day_cost.should == 20
      bike_status.month_cost.should == 56.3
    end
  
  end
  
  describe "Given I have not stored any bike status for my bike" do
  
    it "should generate a hash including only new status " do
      BikeStatus.find_all_for_bike(@bike).should have_key(:rent)
      BikeStatus.find_all_for_bike(@bike)[:rent].should be_instance_of(BikeStatus)
      BikeStatus.find_all_for_bike(@bike)[:rent].should_not be_persisted
      
      BikeStatus.find_all_for_bike(@bike).should have_key(:sell)
      BikeStatus.find_all_for_bike(@bike)[:sell].should be_instance_of(BikeStatus)
      BikeStatus.find_all_for_bike(@bike)[:sell].should_not be_persisted
      
      BikeStatus.find_all_for_bike(@bike).should have_key(:share)
      BikeStatus.find_all_for_bike(@bike)[:share].should be_instance_of(BikeStatus)
      BikeStatus.find_all_for_bike(@bike)[:share].should_not be_persisted
    end
    
    it "should let me create a bike share status" do
      bike_status = BikeStatus.create_with_bike(@bike.id, {availability: "1", concept: Bike.category_for(:statuses, :share), only_friends: "1"})
      BikeStatus.first.should == bike_status
      bike_status.availability.should be_true
      bike_status.concept.should == Bike.category_for(:statuses, :share)
      bike_status.only_friends.should be_true
    end
    
    it "should let me create a bike rent status" do
      bike_status = BikeStatus.create_with_bike(@bike.id, {availability: "1", concept: Bike.category_for(:statuses, :rent), hour_cost: "40", day_cost: "20", month_cost: "56.3" })
      BikeStatus.first.should == bike_status
      bike_status.availability.should be_true
      bike_status.concept.should == Bike.category_for(:statuses, :rent)
      bike_status.hour_cost.should == 40
      bike_status.day_cost.should == 20
      bike_status.month_cost.should == 56.3
    end
    
    it "should let me create a bike sell status" do
      bike_status = BikeStatus.create_with_bike(@bike.id, {availability: "0", concept: Bike.category_for(:statuses, :sell)})
      BikeStatus.first.should == bike_status
      bike_status.availability.should be_false
      bike_status.concept.should == Bike.category_for(:statuses, :sell)
    end
  
  end
  
end