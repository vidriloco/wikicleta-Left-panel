require 'spec_helper'

describe Picture do
  
  before(:each) do
    user = FactoryGirl.create(:user)
    @bike = FactoryGirl.create(:bike, :user => user)
  end
    
  it "for a bike without main picture should have one after adding a first picture" do
    @bike.main_picture.should be_nil
    picture = mock_picture_creation_for(@bike)
    
    bike = Bike.find(@bike.id)
    bike.main_picture.should_not be_nil
    bike.front_picture.should == picture
  end
  
  describe "with a previously automatically assigned main picture" do
    
    before(:each) do
      mock_picture_creation_for(@bike)
    end
    
    it "should NOT set a newer picture as main picture" do
      picture = mock_picture_creation_for(@bike)
      picture.should_not be_a_main_picture
    end
    
  end
  

  
  describe "for a bike with a main picture" do
    
    before(:each) do
      @picture = mock_picture_creation_for(@bike)
    end
    
    it "should remove it if the picture gets removed" do
      bike = Bike.find(@bike.id)
      bike.main_picture.should_not be_nil
      bike.front_picture.should == @picture
      @picture.destroy
      bike = Bike.find(@bike.id)
      bike.main_picture.should be_nil
    end
    
    it "should be a main picture of it's associated imageable model" do
      @picture.should be_a_main_picture
    end
    
  end
  
end

def mock_picture_creation_for(bike)
  file = File.open(Rails.root + 'spec/resources/bike.jpg')
  picture = Picture.new_from(:image => file, :bike_id => bike.id)
  picture.save
  picture
end