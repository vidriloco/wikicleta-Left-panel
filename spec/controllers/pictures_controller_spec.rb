# encoding: utf-8
require 'spec_helper'

describe PicturesController do    
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      bike = FactoryGirl.create(:bike)
      @picture = FactoryGirl.create(:picture, :imageable_id => bike.id, :imageable_type => Bike.to_s)
    end
    
    it "should find the picture and delete it" do
      Picture.should_receive(:find).with("1") { @picture }
      @picture.should_receive(:destroy)
      
      delete :destroy, :id => "1"
    end
    
    it "should render a js template" do
      Picture.stub(:find) { @picture }
      delete :destroy, :format => :js
      
      response.should render_template("update")
    end
    
  end
  
  describe "PUT set main picture for bike (imageable)" do
    
    before(:each) do
      bike = FactoryGirl.create(:bike)
      @picture = FactoryGirl.create(:picture, :imageable_id => bike.id, :imageable_type => Bike.to_s)
    end
    
    it "should find the picture to be set as main picture" do
      Picture.should_receive(:find).with("1") { @picture }
      @picture.should_receive(:become_main_picture)
      
      put :set_main, :id => "1"
    end
    
    it "should render a js template" do
      Picture.stub(:find) { @picture }
      @picture.stub(:become_main_picture)
      put :set_main, :format => :js
      
      response.should render_template("set_main")
    end
    
  end
  
  describe "PUT change caption" do
    
    before(:each) do
      bike = FactoryGirl.create(:bike)
      @picture = FactoryGirl.create(:picture, :imageable_id => bike.id, :imageable_type => Bike.to_s)
    end
    
    it "should find the picture whose caption will be changed" do
      Picture.should_receive(:find).with("1") { @picture }
      @picture.should_receive(:update_attribute).with(:caption, "new value")
      
      put :change_caption, :id => "1", :value => "new value"
    end
    
    it "should render a js template" do
      Picture.stub(:find) { @picture }
      @picture.stub(:update_attribute)
      put :change_caption, :format => :js
      
      response.should render_template("update")
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      bike = FactoryGirl.create(:bike)
      @picture = FactoryGirl.create(:picture, :imageable_id => bike.id, :imageable_type => Bike.to_s)
    end
    
    describe "on successful save" do
    
      before(:each) do
        @picture.stub(:save) { true }
      end
    
      it "should register a new picture" do
        Picture.should_receive(:new_from) { @picture }
        post :create, :format => :js
        response.should be_success
      end
      
    end
    
    describe "on unsuccessful save" do
    
      before(:each) do
        @picture.stub(:save) { false }
      end
    
      it "should register a new picture" do
        Picture.should_receive(:new_from) { @picture }
        post :create, :format => :js
        response.should_not be_success
      end
      
    end
    
  end
  
  
end