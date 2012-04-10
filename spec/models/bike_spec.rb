require 'spec_helper'

describe Bike do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  
  describe "Having a bike registered" do
    
    before(:each) do
      @bike_owner = FactoryGirl.create(:pancho)
      @bike = FactoryGirl.create(:bike, :user => @bike_owner)
    end
    
    it "should tell me it's brand name" do
      @bike.brand.should == @bike.bike_brand.name
    end
    
    it "should tell me who it's is owner" do
      @bike.owner.should == @bike.user.username
    end
    
    it "should let me like it" do
      lambda {
        @bike.register_like_from(@user)
      }.should change(UserLikeBike, :count).by(1)
      
      user_like_bike=UserLikeBike.find_by_user_id_and_bike_id(@user.id, @bike.id)
      user_like_bike.user.should == @user
      user_like_bike.bike.should == @bike
    end

    describe "and already liked by myself" do
      
      before(:each) do
        @bike.register_like_from(@user)
      end
      
      it "should have a like count of 1" do
        @bike.likes_count.should == 1
      end
      
      it "should have a like count of 0 if I unlike it" do
        lambda {
          @bike.destroy_like_from(@user)
        }.should change(@bike, :likes_count).by(-1)
      end

      it "should not add a new like if I like it again" do
        lambda {
          @bike.register_like_from(@user)
        }.should change(UserLikeBike, :count).by(0)
      end

      it "should let me unlike it" do
        lambda {
          @bike.destroy_like_from(@user)
        }.should change(UserLikeBike, :count).by(-1)
        user_like_bike=UserLikeBike.find_by_user_id_and_bike_id(@user.id, @bike.id)
        user_like_bike.should be_nil
      end
    end
    
    describe "for any given category" do
              
      it "should reply with a hash when asked to retrieve it's list" do
        Bike.category_list_for(:types).should be_a(Hash)
      end
      
      it "should retrieve the value for the symbol tandem" do
        Bike.category_for(:types, :tandem).should == 5
      end
        
      it "should retrieve the category symbol associated to an identifier" do
        Bike.category_symbol_for(:types, 5).should == :tandem
      end
      
      it "should retrieve the humanized version associated to a symbol" do
        Bike.humanized_category_for(:types, :mountain).should == I18n.t("bikes.categories.types.mountain")
      end
      
      it "should retrieve a list of humanized version of it's associated symbols" do
        hash = { 
          1 => I18n.t("bikes.categories.locks.none"),
          2 => I18n.t("bikes.categories.locks.chain"),
          3 => I18n.t("bikes.categories.locks.cable"),
          4 => I18n.t("bikes.categories.locks.ulock")
        }
        
        Bike.humanized_categories_for(:locks).should == hash 
      end
      
      it "should retrieve a list of the humanized versions of the symbols I specify" do
        hash = { 
          1 => I18n.t("bikes.categories.locks.none"),
          2 => I18n.t("bikes.categories.locks.chain")
        }
        
        Bike.humanized_categories_for(:locks, :except => [:cable, :ulock]).should == hash
      end
    end
    
  end
end