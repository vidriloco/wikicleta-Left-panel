# encoding: utf-8
require 'spec_helper'

describe BikesController do    
  
  describe "GET new" do
    
    describe "if logged-in" do
    
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
    
      it "should set a new bike instance" do
        get :new
        assigns(:bike).should be_instance_of(Bike)
      end
    
    end
  end
  
  describe "POST create" do
    
    before(:each) do
      @bike = Bike.new(:name => 'any')
    end
    
    describe "if logged-in" do
    
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
    
      it "should receive params and attempt creation of a new bike" do
        Bike.stub(:new_with_owner).with({'name' => 'any'}, @user) { @bike }
  
        post :create, :bike => {'name' => 'any'}
        assigns(:bike).should be(@bike)
      end
    
      describe "with valid parameters" do
    
        before(:each) do
          @bike.stub(:save).and_return(true)
        end

        it "redirects to the bike description page" do
          Bike.stub(:new_with_owner) { @bike }
    
          post :create
          response.should redirect_to(@bike)
        end
        
      end
    
      describe "with invalid parameters" do

        before(:each) do
          @bike.stub(:save).and_return(false)
        end

        it "renders action 'new'" do
          Bike.stub(:new_with_owner) { @bike }
          post :create, :bike => {}
          response.should render_template("new")
        end

      end
    
    end
  end
  
  describe "GET edit" do
    
    describe "if logged-in" do
    
      before(:each) do
        user = FactoryGirl.create(:user)
        sign_in user
        @bike = FactoryGirl.stub(:bike, :user => user)
      end
    
      it "should set a new place instance" do
        Bike.should_receive(:find).with("1").and_return(@bike)
        get :edit, :id => 1
        assigns(:bike).should == @bike
      end
      
      it "should render the edit template" do
        Bike.should_receive(:find).with("1").and_return(@bike)
        get :edit, :id => 1
        response.should render_template(:edit) 
      end
    
    end
    
  end
  
  describe "PUT update" do

    describe "if logged-in" do

      before(:each) do
        user = FactoryGirl.create(:user)
        sign_in user
        @bike = FactoryGirl.create(:bike, :user => user)  
      end

      it "should find the existing bike with the given id" do
        Bike.should_receive(:find).with("1") { @bike }

        put :update, :id => "1"
        assigns(:bike).should be(@bike)
      end

      describe "with valid parameters" do

        before(:each) do
          @bike.stub(:update_attributes).and_return(true)
        end

        it "redirects to the bike details page" do
          Bike.stub(:find).with("1") { @bike }

          put :update, :id => "1", :bike => {'some' => 'params'}
          response.should redirect_to(@bike)
        end

      end

      describe "with invalid parameters" do

        before(:each) do
          @bike.stub(:update_attributes).and_return(false)
        end

        it "renders action 'edit'" do
          Bike.stub(:find) { @bike }
          put :update, :id => "1"
          response.should render_template("edit")
        end

      end
    end
  end
  
  describe "GET show" do
    
    before(:each) do
      @bike = Bike.new
      @statuses = {}
    end
    
    it "should fetch a bike and assign it to bike" do
      Bike.should_receive(:find).with("1") { @bike }
      get :show, :id => "1"
    
      assigns(:bike).should == @bike
      response.should be_successful
    end
    
    it "should fetch a bike statuses and assign them to statuses" do
      Bike.stub(:find) { @bike }
      BikeStatus.should_receive(:find_all_for_bike) { @statuses }
      get :show, :id => "1"
      
      assigns(:statuses).should == @statuses
      response.should be_successful
    end
  
  end
  
  describe "GET index" do
    
    before(:each) do
      @bikes = []
    end
    
    it "should fetch all the bikes ordered by date" do
      Bike.should_receive(:order) { @bikes }
      get :index
      assigns(:bikes).should == @bikes
    end
    
    it "should render it's template" do
      get :index
      response.should render_template("index")
    end
    
  end
  
  describe "GET popular" do
    
    before(:each) do
      @bikes = []
    end
    
    it "should fetch all the bikes with ordering showing the most popular first" do
      Bike.should_receive(:most_popular) { @bikes }
      get :popular
      assigns(:bikes).should == @bikes
    end
    
    it "should render it's template" do
      get :popular
      response.should render_template("index")
    end
    
  end
  
  describe "GET mine" do
    
    before(:each) do
      user = FactoryGirl.create(:user)
      sign_in user
      @bikes = []
    end
    
    it "should fetch all the bikes which are mine" do
      Bike.should_receive(:all_from_user) { @bikes }
      get :mine
      assigns(:bikes).should == @bikes
    end
    
    it "should render it's template" do
      get :mine
      response.should render_template("index")
    end
    
  end
  
end
