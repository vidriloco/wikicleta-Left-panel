# encoding: utf-8
require 'spec_helper'

describe PlacesController do    
  
  describe "GET new" do
    
    describe "if logged-in" do
    
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end
    
      it "should set a new place instance" do
        get :new
        assigns(:place).should be_instance_of(Place)
      end
    
    end
  end
  
  describe "GET edit" do
    
    describe "if logged-in" do
    
      before(:each) do
        @user = Factory(:user)
        @place = Factory(:recent_place)
        sign_in @user
      end
    
      it "should set a new place instance" do
        Place.should_receive(:find).with("1") { @place }
        get :edit, :id => 1
        assigns(:place).should == @place
      end
    
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @place = Place.new
    end
    
    describe "if logged-in" do
    
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end
    
      it "should receive params and attempt creation of a new place" do
        Place.stub(:new_with_owner).with({'name' => 'any'}, @user) { @place }
        @place.should_receive(:apply_geo).with({"lat" => "19.45", "lon" => "-99.23"})
  
        post :create, :place => {'name' => 'any'}, :coordinates => {:lat => "19.45", :lon => "-99.23"}
        assigns(:place).should be(@place)
      end
    
      describe "with valid parameters" do
    
        before(:each) do
          @place.stub(:save).and_return(true)
        end

        it "redirects to the newly created place" do
          Place.stub(:new_with_owner) { @place }
          @place.stub(:apply_geo)
    
          post :create
          response.should redirect_to(@place)
        end
        
      end
    
      describe "with invalid parameters" do

        before(:each) do
          @place.stub(:save).and_return(false)
        end

        it "renders action 'new'" do
          Place.stub(:new_with_owner) { @place }
          post :create, :place => {}, :coordinates => {}
          response.should render_template("new")
        end

      end
    
    end
  end
  
  describe "PUT update" do

    before(:each) do
      @place = Place.new
    end

    describe "if logged-in" do

      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end

      it "should receive params and attempt update of an existing place" do
        Place.stub(:find).with("37") { @place }

        @place.should_receive(:update_attributes).with({'these' => 'params'})
        @place.should_receive(:apply_geo).with({"lat" => "19.2232", "lon" => "-99.343"})

        put :update, :id => "37", :place => {'these' => 'params'}, :coordinates => {:lat => 19.2232, :lon => -99.343}
        assigns(:place).should be(@place)
      end

      describe "with valid parameters" do

        before(:each) do
          @place.stub(:update_attributes).and_return(true)
        end

        it "redirects to the newly created place" do
          Place.stub(:find).with("11") { @place }
          @place.stub(:apply_geo)

          put :update, :id => "11"
          response.should redirect_to(@place)
        end

      end

      describe "with invalid parameters" do

        before(:each) do
          @place.stub(:update_attributes).and_return(false)
        end

        it "renders action 'edit'" do
          Place.stub(:find) { @place }
          put :update, :id => "11"
          response.should render_template("edit")
        end

      end
    end
  end

  describe "GET index" do
  
    before(:each) do
      @categories = Category.all
      @places = []
    end
  
    it "should respond to index action when parameters NOT given" do
      Category.should_receive(:all).and_return(@categories)
      Place.should_receive(:order).and_return(@places)
    
      get :index
    
      assigns(:categories).should == @categories
    
      assigns(:places).should == @places
      response.should be_successful
    end
  
    it "should respond to index action when parameters given" do
      Category.should_not_receive(:all)
      Place.should_receive(:filtering_with).with("some-order", ["1","2"]).and_return(@places)
    
      get :index, :ordered_by => 'some-order', :categories => ["1","2"], :filtered => true
    
      assigns(:categories).should be_nil
      assigns(:places).should == @places
      response.should be_successful
    end
  
  end
  
  describe "GET show" do
    
    before(:each) do
      @place = Place.new
    end
    
    it "should fetch a place and make it available to the view" do
      Place.should_receive(:find).with("1") { @place }
      get :show, :id => "1"
    
      assigns(:place).should == @place
      response.should be_successful
    end
  
  end
  
end
