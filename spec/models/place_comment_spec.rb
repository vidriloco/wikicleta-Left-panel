require 'spec_helper'

describe PlaceComment do
  
  describe "Pancho posted a comment to a place then" do
    before(:each) do
      place = Factory(:accessible_place)
      @user = Factory(:pancho)
      @place_comment = place.add_comment(@user, "Buen comentario")
    end
    
    it "asking the comment if it's owner is Pancho should reply with true" do
      @place_comment.owned_by?(@user).should be_true
    end
    
    it "asking the comment if it's owner is Pipo should reply with false" do
      @place_comment.owned_by?(Factory(:pipo)).should be_false
    end
  end
  
end