#encoding: utf-8
require 'spec_helper'

describe Friendship do
  
  before(:each) do
    @friend = FactoryGirl.create(:user)
    @pipo = FactoryGirl.create(:pipo)
  end
  
  describe "Given pipo has added a friend" do
  
    before(:each) do
      @friendship = Friendship.create(:user_id => @pipo.id, :friend_id => @friend.id)
    end
  
    it "should have a latent friendship awaiting approval of it's future friend" do
      @pipo.all_friendships.first.should_not be_reciprocal
    end
    
    it "should appear to the future friend a friend request from pipo" do
      @friend.all_friendships.first.should_not be_reciprocal
    end
    
    it "should retrieve the friendship with pipo" do
      @friend.friendship_with(@pipo).should == @friendship
    end
    
    it "should retrieve the friendship with pipo" do
      @pipo.friendship_with(@friend).should == @friendship
    end
    
    it "should reply with yes when asking if pipo sent invitation first" do
      @friendship.started_by?(@pipo).should be_true
    end
    
    it "should reply with false when asking if pipo's friend sent invitation first" do
      @friendship.started_by?(@friend).should be_false
    end
    
    describe "and his friend has recognized him and accepted the invitation" do
      
      before(:each) do
        @friend.all_friendships.first.update_attribute(:confirmed, true)
      end
      
      it "should appear to pipo as a friend" do
        @pipo.all_friendships.first.should be_reciprocal
      end
      
      it "should appear to pipo's friend as friend of pipo" do
        @friend.all_friendships.first.should be_reciprocal
      end
      
    end
  
  end
end