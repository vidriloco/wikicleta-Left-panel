require 'spec_helper'

describe Place do
  
  before(:each) do
    @user = Factory(:pipo)
  end
  
  describe "When registering a new place" do
    
    before(:each) do
      @place = Place.new_with_owner(FactoryGirl.attributes_for(:popular_place, :category => FactoryGirl.create(:workshop)), @user)
      @place.save      
    end
    
    it "should add the registerer as recommender and as owner" do
      recommending = @place.recommendations.first
      recommending.place.should == @place
      recommending.user.should == @user
      recommending.is_owner.should be_true
    end
    
    it "should confirm that the registerer is it's owner" do
      @place.owned_by?(@user).should be_true
    end
     
  end
  
  
  describe "having three places registered" do
    
    before(:each) do
      @place_one = FactoryGirl.create(:popular_place, :category => FactoryGirl.create(:restaurant))
      @place_two = FactoryGirl.create(:recent_place, :category => FactoryGirl.create(:cinema))
      @place_three = FactoryGirl.create(:accessible_place, :category => FactoryGirl.create(:museum))
      
      @pancho =  FactoryGirl.create(:pancho)
    end
    
    it "filtering by popular store should retrieve one record only" do
      Place.filtering_with(:most_recommended, [@place_one.category.id]).should == [@place_one]
    end
    
    it "filtering by nothing but categories store and museum should retrieve two records" do
      results = Place.filtering_with(:nothing, [@place_one.category.id, @place_three.category.id])
      
      results.should include(@place_three)
      results.should include(@place_one)
      results.size.should == 2
    end
    
    describe "searching" do
      
      it "should find all matching a given name" do
        search_hash={:place => {:name => @place_two.name}}
        Place.find_by(search_hash).should == [@place_two]
      end
      
      it "should find all matching a given description" do
        search_hash={:place => {:description => @place_two.description}}
        Place.find_by(search_hash).should == [@place_two]
      end
      
      it "should find all matching the selected categories" do
        search_hash={:place => {:categories => { @place_one.category.id => "on", @place_three.category.id => "on" }}}
        Place.find_by(search_hash).should == [@place_one, @place_three]
      end
      
      it "should find all matching a given partial name and partial description" do
        search_hash={:place => {:description => @place_two.description[3,9], :name => @place_two.name[4,8]}}
        Place.find_by(search_hash).should == [@place_two]
      end
      
      it "should find those matching a given description, categories and name" do
        search_hash={:place => {:description => @place_one.description, :name => @place_one.name, :categories => {@place_one.category.id => "on"}}}
        Place.find_by(search_hash).should == [@place_one]
      end
      
      it "should NOT find a place with an innexistant name even though a valid category has been selected" do
        search_hash={:place => {:name => "Pepito's place", :categories => {@place_one.category.id => "on"}}}
        Place.find_by(search_hash).should == []
      end
      
    end
    
    
    describe "and place one has two add_recommenders" do
      
      before(:each) do
        @place_one.add_recommender(@user)
        @place_one.add_recommender(@pancho)
        @place_one.save
      end
      
      it "should retrieve them ordered by their number of recommenders" do
        order = Place.order("recommendations_count DESC")
        order.first.should == @place_one
      end
      
    end
    
    it "should let me add a new owner to any of them" do
      @place_two.add_recommender(@user, [:owner])
      @place_two.owned_by?(@user).should be_true
    end
    
    it "should let me add a new verified owner to any of them" do
      @place_one.add_recommender(@user, [:owner, :verified])
      @place_one.verified_owner_is?(@user).should be_true
    end
    
    describe "and place two has two recommenders" do
      
      before(:each) do
        @place_two.add_recommender(@user)
        @place_two.add_recommender(@pancho)
        @place_two.save
      end
      
      it "should retrieve them ordered by their number of recommenders" do
        order = Place.order("recommendations_count DESC")
        order.first.should == @place_two
      end
      
      it "should let me know if a user is a recommender or not" do
        @place_one.recommended_by?(@user).should be_false
        @place_two.recommended_by?(@pancho).should be_true
      end
      
      it "should let me change the recommendation status for a user" do
        @place_one.change_recommendation_status_for(@user, :on)
        @place_one.recommended_by?(@user).should be_true
        
        @place_two.change_recommendation_status_for(@pancho, :off)
        @place_two.recommended_by?(@pancho).should be_false
      end
      
    end
    
    it "should NOT allow Pipo to add an announcement to a place given he is not a verified owner" do
      announcement_hash = {:header => "An announcement", :message => "A message", :start_date => Time.now-5, :end_date => Time.now+5}
      @place_one.add_announcement(@user, announcement_hash).should be_false
    end
    
    describe "given PIPO is now a verified owner of a place" do
      
      before(:each) do
        @place_one.add_recommender(@user, [:owner, :verified])
      end
      
      it "should allow him to add an announcement to a place" do
        announcement_hash = {:header => "An announcement", :message => "A message", :start_date => Time.now-5, :end_date => Time.now+5}
        @place_one.add_announcement(@user, announcement_hash).should be_true
      end
      
      it "should not save an announcement whose start and end dates are not correct" do
        announcement_hash = {:header => "An announcement", :message => "A message", :start_date => Time.now+50, :end_date => Time.now+5}
        @place_one.add_announcement(@user, announcement_hash).should_not be_persisted
      end
      
      it "should correctly parse a pair of date hash values when adding an announcement" do
        dates = {:start_date => {"year" => "2012", "month" => "1", "day" => "23", "hour" => "5", "minute" => "30"}, 
                 :end_date => {"year" => "2012", "month" => "7", "day" => "3", "hour" => "16", "minute" => "15"}}
        announcement_hash = {:header => "An announcement", :message => "A message"}.merge(dates)

        announcement = @place_one.add_announcement(@user, announcement_hash)
        announcement.start_date.should == Time.local(2012, 1, 23, 5, 30)
        announcement.end_date.should == Time.local(2012, 7, 3, 16, 15)
      end
    end
    
    it "should allow me to change the coordinates of a place" do
      @place_one.apply_geo({"lat" => "19.4", "lon" => "-99.15"})
      @place_one.coordinates.lat.should == 19.4
      @place_one.coordinates.lon.should == -99.15
    end
    
    it "should let me add a comment to one of them" do
      @place_one.add_comment(@user, "Nice comment")
      @place_one.place_comments.size.should == 1
      @place_one.place_comments.first.content.should == "Nice comment"
    end
  end
 
end