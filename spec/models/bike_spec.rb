require 'spec_helper'

describe Bike do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  
  describe "Having a bike registered" do
    
    before(:each) do
      @bike = FactoryGirl.create(:bike, :user => FactoryGirl.create(:pancho))
    end
    
    it "should let me like it" do
      lambda {
        @bike.register_like_from(@user)
      }.should change(UserLikeBike, :count).by(1)
      
      user_like_bike=UserLikeBike.find_by_user_id_and_bike_id(@user.id, @bike.id)
      user_like_bike.user.should == @user
      user_like_bike.bike.should == @bike
    end

    describe "with a like from me" do
      
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
  end
end