require 'spec_helper'

describe Place do
  
  describe "When registering a new place" do
    
    before(:each) do
      @user = Factory(:pipo)
      @place = Place.new_with_owner(FactoryGirl.attributes_for(:popular_place, :category => Factory(:workshop)), @user)
      @place.save      
    end
    
    it "should add the registerer as follower and as owner" do
      following = @place.follows.first
      following.place.should == @place
      following.user.should == @user
      following.is_owner.should be_true
    end
    
    it "should confirm that the registerer is it's owner" do
      @place.owned_by?(@user).should be_true
    end
     
  end
  
  
  describe "having three places registered" do
    
    before(:each) do
      @place_one = Factory(:popular_place)
      @place_two = Factory(:recent_place)
      @place_three = Factory(:accessible_place, :category => Factory.build(:museum))
      
      @pipo = Factory(:pipo)
      @pancho =  Factory(:pancho)
    end
    
    it "filtering by popular store should retrieve one record only" do
      Place.filtering_with(:popular, [@place_one.category.id]).should == [@place_one]
    end
    
    it "filtering by nothing but categories store and museum should retrieve two records" do
      results = Place.filtering_with(:nothing, [@place_one.category.id, @place_three.category.id])
      
      results.should include(@place_three)
      results.should include(@place_one)
      results.size.should == 2
    end
    
    describe "and place one has two followers" do
      
      before(:each) do
        @place_one.follows.build(:user => @pipo)
        @place_one.follows.build(:user => @pancho)
        @place_one.save
      end
      
      it "should retrieve them ordered by their number of followers" do
        order = Place.order("followers_count DESC")
        order.first.should == @place_one
      end
            
    end
    
    describe "and place two has two followers" do
      
      before(:each) do
        @place_two.follows.build(:user => @pipo)
        @place_two.follows.build(:user => @pancho)
        @place_two.save
      end
      
      it "should retrieve them ordered by their number of followers" do
        order = Place.order("followers_count DESC")
        order.first.should == @place_two
      end
      
    end

    it "should allow me to change the coordinates of a place" do
      @place_one.apply_geo({"lat" => "19.4", "lon" => "-99.15"})
      @place_one.coordinates.lat.should == 19.4
      @place_one.coordinates.lon.should == -99.15
    end
      
  end
  
  
 
end