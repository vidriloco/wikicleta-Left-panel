# encoding: utf-8
require 'spec_helper'

describe Places::CommitsController do    
  
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
      @place = Factory.build(:popular_place)
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
  
  
  
  describe "if logged-in" do
    
    before(:each) do
      @user = Factory(:user)
      sign_in @user
    end
    
    describe "with a place registered" do
      
      before(:each) do
        @place = Factory(:popular_place)
      end
      
      describe "PUT update" do

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
      
      describe "POST comment" do
        
        it "should receive some params and register a new comment" do
          Place.should_receive(:find).with("1") { @place }
          @place.should_receive(:add_comment).with(@user, "One comment")
          
          post :comment, :id => "1", :place_comment => {:content => "One comment"}
          assigns(:place).should be(@place)
        end
        
      end
            
      describe "DELETE uncomment" do
        
        before(:each) do
          @comment = PlaceComment.new
        end
        
        describe "when logged-in user is the comment owner" do
          
          before(:each) do
            @comment.stub(:owned_by?) { true }
          end
          
          it "should succeed on deleting the comment" do
            PlaceComment.should_receive(:find).with("1") { @comment }
            @comment.should_receive(:destroy).and_return(true)
          
            delete :uncomment, :id => "1"
          
            assigns(:place_comment_destroyed).should be_true
          end
        end
        
        describe "when logged-in user is the comment owner" do
          
          before(:each) do
            @comment.stub(:owned_by?) { false }
          end
          
          it "should NOT succeed on deleting the comment and render an empty response" do
            PlaceComment.should_receive(:find).with("1") { @comment }
            @comment.should_not_receive(:destroy)
            
            delete :uncomment, :id => "1"
            
            response.body.should be_blank
          end
          
        end
        
      end
      
      describe "POST announce" do
        
        before(:each) do
          @announcement = Announcement.new
        end
        
        describe "when logged-in user is owner and is verified" do
      
          before(:each) do
            @place.stub(:add_announcement) { true }
          end
      
          it "should succeed on posting an announcement" do 
            Place.should_receive(:find).with("1") { @place }
        
            post :announce, :place_id => "1", :announcement => { :header => "some header", :message => "a message" }
            assigns(:announcement).should be_true
          end
          
        end
        
        describe "when logged-in user is NOT a verified owner" do
          
          before(:each) do
            @place.stub(:add_announcement) { false }
          end
          
          it "should fail on posting an announcement and respond with an empty response" do 
            Place.should_receive(:find).with("1") { @place }
        
            post :announce, :place_id => "1"
            
            response.body.should be_blank
          end
          
        end 
        
      end
         
      describe "DELETE unannounce" do
        
        before(:each) do
          @announcement = Announcement.new
          @announcement.stub(:place) { @place }
        end
        
        describe "when logged-in user is owner and is verified" do
      
          before(:each) do
            @place.stub(:verified_owner_is?) { true }
          end
      
          it "should succeed on deleting an announcement" do 
            Announcement.should_receive(:find).with("1") { @announcement }
            @announcement.should_receive(:destroy) { true }
        
            delete :unannounce, :id => "1"
            assigns(:announcement_destroyed).should be_true
          end
          
        end  
          
        describe "when logged-in user is NOT a verified owner" do
        
          before(:each) do
            @place.stub(:verified_owner_is?) { false }
          end
        
          it "should NOT succeed on deleting an announcement and render an empty response" do
            Announcement.should_receive(:find).with("1") { @announcement }
            
            delete :unannounce, :id => "1"
            
            response.body.should be_blank
          end
          
        end
      end
      
    end
  end
      

  
  
  
end