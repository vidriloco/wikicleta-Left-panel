#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Individual description of places: ' do
  
  describe "Given Taller del Costumbre has been just registered" do
    
    before(:each) do
      @user = Factory(:pipo)
      attrs = Factory.attributes_for(:recent_place, :name => "Taller del Costumbre", :mobility_kindness_index => 9, :category => Factory(:workshop), :twitter => "elcostumbre")
      @costumbre= Place.new_with_owner(attrs, @user)
      @costumbre.save
    end
    
    scenario "clicking on the place name from the places listing page should bring me to the place description page" do
      visit places_path
      click_on @costumbre.name
      current_path.should == place_path(@costumbre)
    end
    
    scenario "reviewing it's details should be possible" do
      visit place_path(@costumbre)
            
      within('#main-box') do
        
        page.should have_content @costumbre.name
        page.should have_content @costumbre.address
        page.should have_content @costumbre.twitter
        find_button I18n.t('places.common_actions.follow')
        page.should have_content @costumbre.description
      
        page.should have_content I18n.t('connectives.by') 
        page.should have_content @user.username
      
        within("#status-bar") do
      
          within(".followers") do
            page.should have_content @costumbre.followers_count
            page.should have_content I18n.t('places.views.show.followers')
          end
      
          within(".photos") do
            page.should have_content @costumbre.photos_count
            page.should have_content I18n.t('places.views.show.photos')
          end
      
          within(".announcements") do
            page.should have_content @costumbre.announcements.count
            page.should have_content I18n.t('places.views.show.announcements')
          end
      
          within(".comments") do
            page.should have_content @costumbre.comments_count
            page.should have_content I18n.t('places.views.show.comments')
          end
        
          page.should have_content @costumbre.mobility_kindness_index
          page.should have_content Place.human_attribute_name(:mobility_kindness_index)
        
          find_link I18n.t('places.views.show.how_to_arrive')
        end
      
        within('#tabbed-content') do
          page.should have_content I18n.t('places.views.show.empty.followers')
          find_button I18n.t('places.common_actions.follow')
        end
        
      end
      
      page.has_css?('#side-box').should be_true
      
    end
    
    describe "and someone changes it's address to an empty valued field it" do
      
      before(:each) do
        @costumbre.update_attribute(:address, "")
      end
      
      it "should show Google's geolocated approximate address", :js => true do
        visit place_path(@costumbre)
        within('#main-box') do
          page.should have_content "Nuevo León 198, Hipódromo, Cuauhtémoc, Mexico City, Distrito Federal, Mexico"
        end
        
        page.has_css?('#side-box').should be_true
      end
      
    end
    
    describe "and someone changes it's twitter account to an empty valued field it" do
      before(:each) do
        @costumbre.update_attribute(:twitter, "")
      end
      
      it "should not show it" do
        visit place_path(@costumbre)
        within('#main-box') do
          page.has_css?('.twitter').should be_false
          page.should_not have_content "@"
        end
        
        page.has_css?('#side-box').should be_true
      end
    end    
    
    describe "having three transit stops nearby" do
      
      it "should show them in the sidebar"
      
    end
    
    describe "being registered five similar places" do
      
      it "should show them in the sidebar"
      
    end
    
    
    
  end
  
end