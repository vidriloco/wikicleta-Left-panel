#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Individual description of places: ' do
  
  describe "Given Taller del Costumbre has been just registered" do
    
    before(:each) do
      @user = Factory(:pipo)
      attrs = Factory.attributes_for(:recent_place, :name => "Taller del Costumbre", :mobility_kindness_index => 9, :category => Factory(:workshop), :twitter => "elcostumbre")
      @taller_costumbre= Place.new_with_owner(attrs, @user)
      @taller_costumbre.save
    end
    
    scenario "clicking on the place name from the places listing page should bring me to the place description page" do
      visit places_path
      click_on @taller_costumbre.name
      current_path.should == place_path(@taller_costumbre)
    end
    
    scenario "reviewing it's details should be possible" do
      visit place_path(@taller_costumbre)
            
      within('#main-box') do
        
        page.should have_content @taller_costumbre.name
        page.should have_content @taller_costumbre.address
        page.should have_content @taller_costumbre.twitter
        find_button I18n.t('places.common_actions.follow')
        page.should have_content @taller_costumbre.description
      
        page.should have_content I18n.t('connectives.by') 
        page.should have_content @user.username
      
        within("#status-bar") do
      
          within(".followers") do
            page.should have_content @taller_costumbre.followers_count
            page.should have_content I18n.t('places.views.show.followers').singularize
          end
      
          within(".photos") do
            page.should have_content @taller_costumbre.photos_count
            page.should have_content I18n.t('places.views.show.photos')
          end
      
          within(".announcements") do
            page.should have_content @taller_costumbre.announcements.count
            page.should have_content I18n.t('places.views.show.announcements')
          end
      
          within(".comments") do
            page.should have_content @taller_costumbre.comments_count
            page.should have_content I18n.t('places.views.show.comments')
          end
        
          page.should have_content @taller_costumbre.mobility_kindness_index
          page.should have_content Place.human_attribute_name(:mobility_kindness_index)
        
          find_link I18n.t('places.views.show.how_to_arrive')
        end
      
        within('#tabbed-content') do
          page.should have_content I18n.t('places.subviews.show.followers.empty')
          find_button I18n.t('places.common_actions.follow')
        end
        
      end
      
      page.has_css?('#side-box').should be_true
      
    end
    
    describe "and someone changes it's address to an empty valued field it" do
      
      before(:each) do
        @taller_costumbre.update_attribute(:address, "")
      end
      
      it "should show Google's geolocated approximate address", :js => true do
        visit place_path(@taller_costumbre)
        within('#main-box') do
          page.should have_content "De La Virgen, Metro Coyoacán, Mexico City, Distrito Federal, Mexico"
        end
        
        page.has_css?('#side-box').should be_true
      end
      
    end
    
    describe "and someone changes it's twitter account to an empty valued field it" do
      before(:each) do
        @taller_costumbre.update_attribute(:twitter, "")
      end
      
      it "should not show it" do
        visit place_path(@taller_costumbre)
        within('#main-box') do
          page.has_css?('.twitter').should be_false
          page.should_not have_content "@"
        end
        
        page.has_css?('#side-box').should be_true
      end
    end    
    
    describe "considering I have not yet ranked this place mobility" do
        
      it "should let me see the ranking questions and rank the place" #do
=begin        visit place_path(@taller_costumbre)
        click_on I18n.t('places.subviews.show.mobility_index.unranked')
        
        within('#mobility-ranking') do
          page.should have_content I18n.t('places.subviews.show.mobility_index.title')
          
          within("##{Question.first.id}") do
            page.should have_content I18n.t('descriptors.questions.mobility.bike_parking')
            page.should have_content I18n.t('descriptors.common_answers.yes')
            page.should have_content I18n.t('descriptors.common_answers.no')
          end
          
          within("##{Question.last.id}") do
            page.should have_content I18n.t('descriptors.questions.mobility.bike_easy_arriving')
            page.should have_content I18n.t('descriptors.common_answers.yes')
            page.should have_content I18n.t('descriptors.common_answers.no')
          end
        end

      end
=end    
    end
    
    
    describe "having three transit stops nearby" do
      
      it "should show them in the sidebar"
      
    end
    
    describe "being registered five similar places" do
      
      it "should show them in the sidebar"
      
    end
    
    
    
  end
  
end