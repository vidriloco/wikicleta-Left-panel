#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Follows in places HTML show:' do
  
  describe "Given I'm reviewing a registered place" do
    
    before(:each) do
      @user = Factory(:user)
      attrs = Factory.attributes_for(:recent_place, :name => "Fondita de Doña Pina", :mobility_kindness_index => 9, :category => Factory(:restaurant), :twitter => "")
      @fondita = Place.new_with_owner(attrs, @user)
      @fondita.save
    end
    
    describe "and if I'm not logged-in" do
      scenario "clicking on the follow button should trigger a login required message", :js => true do
        visit place_path(@fondita)
        click_button I18n.t('places.common_actions.follow')
        page.should have_content I18n.t('places.messages.error.login_required', :action => I18n.t('places.messages.error.complements.follow'))
      end
    end
    
    describe "if I'm logged-in and I am the owner of the place it" do
    
      before(:each) do
        login_with(@user)
      end
    
      it "should show it as being followed by me" do
        visit place_path(@fondita)
        within('#main-box') do
          find_button I18n.t('places.common_actions.following')
          
          within('#tabbed-content') do
            page.should have_content @user.username
            page.should have_content I18n.t('places.common_actions.owning')
            page.should have_content I18n.t('places.views.show.empty.followers')
            find_button I18n.t('places.common_actions.following')
          end
        end
      end
      
      it "should not allow me to unfollow it"
      
    end
    
    describe "if I'm logged-in and I am NOT the owner of the place it", :js => true do
      
      before(:each) do
        login_with(Factory(:pancho))
      end
      
      it "should let me follow a place I don't yet follow" do
        visit place_path(@fondita)
        within('#main-box') do
          click_button I18n.t('places.common_actions.follow')
          find_button I18n.t('places.common_actions.following')
          
          within('#tabbed-content') do
            page.should_not have_content I18n.t('places.views.show.empty.followers')
          end
          
          within(".followers") do
            page.should have_content 2
            page.should have_content I18n.t('places.views.show.followers')
          end
          
          click_button I18n.t('places.common_actions.following')
          find_button I18n.t('places.common_actions.follow')
          
          within('#tabbed-content') do
            page.should have_content I18n.t('places.views.show.empty.followers')
            find_button I18n.t('places.common_actions.follow')
          end
          
          within(".followers") do
            page.should have_content 1
            page.should have_content I18n.t('places.views.show.followers').singularize
          end
        end
      end
    end
    
    describe "having two followers it" do
      
      before(:each) do
        @pancho = FactoryGirl.build(:pancho)
        @pipo = FactoryGirl.build(:pipo)
        @fondita.add_follower(@pancho)
        @fondita.add_follower(@pipo)
      end
      
      it "should display them on the listings" do
        visit place_path(@fondita)
        
        within('#main-box') do
          
          within("#status-bar") do

            within(".followers") do
              page.should have_content I18n.t('places.views.show.followers')
              page.should have_content 3
            end
            
          end
          
          within('#tabbed-content') do
            within("#follower-#{@user.id}") do
              page.should have_content @user.username
              page.should have_content I18n.t('places.common_actions.owning')
              page.has_css?('.image').should be_true
            end
            
            within("#follower-#{@pancho.id}") do
              page.should have_content @pancho.username
              page.has_css?('.image').should be_true
            end
            
            within("#follower-#{@pipo.id}") do
              page.should have_content @pipo.username
              page.has_css?('.image').should be_true
            end
          end
          
        end
        
      end
    end
    
  end
  
end