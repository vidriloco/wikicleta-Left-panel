#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Recommendations in places HTML show:' do
  
  describe "Given I'm reviewing a registered place" do
    
    before(:each) do
      @user = Factory(:user)
      attrs = Factory.attributes_for(:recent_place, :name => "Fondita de Doña Pina", :mobility_kindness_index => 9, :category => Factory(:restaurant), :twitter => "")
      @fondita = Place.new_with_owner(attrs, @user)
      @fondita.save
    end
    
    describe "and if I'm not logged-in" do
      scenario "clicking on the 'recommend' button should trigger a login required message", :js => true do
        visit place_path(@fondita)
        click_button I18n.t('places.common_actions.recommend')
        page.should have_content I18n.t('places.messages.error.login_required', :action => I18n.t('places.messages.error.complements.recommend'))
      end
    end
    
    describe "if I'm logged-in and I am the owner of the place it" do
    
      before(:each) do
        login_with(@user)
      end
    
      it "should show it as being already recommended by me" do
        visit place_path(@fondita)
        within('#main-box') do
          find_button I18n.t('places.common_actions.recommending')
        end
      end
      
      it "should not allow me to stop recommending it", :js => true do
        visit place_path(@fondita)
        within('#main-box') do
          click_button I18n.t('places.common_actions.recommending')
        end
        
        page.should have_content I18n.t('places.messages.error.only_owner_cannot_stop_recommending')
      end
      
    end
    
    describe "if I'm logged-in and I am NOT the owner of the place it", :js => true do
      
      before(:each) do
        login_with(Factory(:pancho))
      end
      
      it "should let me recommend a place I haven't yet recommended" do
        visit place_path(@fondita)
        within('#main-box') do
          click_button I18n.t('places.common_actions.recommend')
          find_button I18n.t('places.common_actions.recommending')
        end
      end
    end
  end
  
end