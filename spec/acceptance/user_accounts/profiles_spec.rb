#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Reviewing the profile of pipo' do
  
  describe "Given it exists" do
    
    before(:each) do
      @user = FactoryGirl.create(:pipo)
    end
    
    scenario "Can see it's profile info" do
      visit user_profile_path(@user.username)
      
      page.should have_content @user.username
      page.should have_content @user.full_name
      
      page.should have_content @user.bio
      page.should have_content @user.personal_page
      page.should_not have_content @user.email
    end
    
    describe "If I am allowing my email to be displayed on my profile" do
      
      before(:each) do
        @user.update_attribute(:email_visible, true)
      end
      
      scenario "then I should see it" do
        visit user_profile_path(@user.username)

        page.should have_content @user.email
      end
      
    end
    
    describe "Given he has added it's twitter and facebook accounts" do
      
      before(:each) do
        FactoryGirl.create(
          :authorization, 
          :uid => "738423979", 
          :token => "AAADt7srPS1sBAGTRZBaM65ASnslnBM1ZCdzY5hVFML1b2zdZBHzU9AaQi2bd9oKlx9uiPPfNWgGLuG0mZAikWZAcQVpTttLCaBZCnX5CkjNQZDZD", 
          :provider => "facebook", :secret => "secrfb", :user_id => @user.id)
        FactoryGirl.create(:authorization, :uid => "68425522", :provider => "twitter", :secret => "secrtw", :user_id => @user.id)
      end
      
      scenario "should see it's social accounts info" do
        visit user_profile_path(@user.username)

        within('.social-nets') do
          page.should_not have_content I18n.t('user_profiles.views.social_nets.none')
          page.should have_css('.facebook')
          page.should have_css('.twitter')
        end
      end
      
    end
    
    scenario "but he has not yet registered a bike then I see a message that tells me so" do
      visit user_profile_path(@user.username)
      click_link I18n.t('user_profiles.menu.bikes')
      page.current_path.should == user_profile_path(@user.username)
      page.should have_content I18n.t('user_profiles.views.bikes.none')
    end
    
    describe "and he has a bike registered" do
      
      before(:each) do
        @bike = FactoryGirl.create(:bike, :user => @user)
      end
      
      scenario "I should see it listed" do
        visit user_profile_path(@user.username)

        click_link I18n.t('user_profiles.menu.bikes')
        
        page.should have_content @bike.name
      end
      
    end
    
  end
  
end