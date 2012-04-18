#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Bike sharing, renting and selling:" do
  
  before(:each) do
    @user = FactoryGirl.create(:pancho)
    @bike = FactoryGirl.create(:bike, :user => @user)
  end
  
  scenario "When no status has been set, the I should see all the possible status set to not available" do
    visit bike_path(@bike)
    
    within("#share-box") do
      page.should have_content Bike.humanized_category_for(:statuses, :share)
      page.should have_content I18n.t('bike_statuses.views.index.status.not_available')
    end
    
    within("#rent-box") do
      page.should have_content Bike.humanized_category_for(:statuses, :rent)
      page.should have_content I18n.t('bike_statuses.views.index.status.not_available')
    end
    
    within("#sell-box") do
      page.should have_content Bike.humanized_category_for(:statuses, :sell)
      page.should have_content I18n.t('bike_statuses.views.index.status.not_available')
    end
  end
  
  describe "If I am signed in" do
    
    before(:each) do
      login_with(@user)
    end
  
    scenario "I can set my bike share state to shared and share-it with all or with my friends only", :js => true do
      visit bike_path(@bike)
      
      within("#share-box") do
        page.should have_content I18n.t('bike_statuses.views.index.status.not_available') 
        find('.reveals-share').click        
      end
      
      within('#share-modal') do
        page.select I18n.t('common_answers')[true], :from => 'bike_status_availability'
        uncheck 'bike_status_only_friends'
        click_on I18n.t('actions.save')
      end
      
      within("#share-box") do
        page.should have_content I18n.t('bike_statuses.views.index.share.only_friends')[false]
        find('.reveals-share').click        
      end
      
      within('#share-modal') do
        page.select I18n.t('common_answers')[true], :from => 'bike_status_availability'
        check 'bike_status_only_friends'
        click_on I18n.t('actions.save')
      end
      
      within("#share-box") do
        page.should have_content I18n.t('bike_statuses.views.index.share.only_friends')[true]
        find('.reveals-share').click        
      end
      
      within('#share-modal') do
        page.select I18n.t('common_answers')[false], :from => 'bike_status_availability'
        click_on I18n.t('actions.save')
      end
      
      within("#share-box") do
        page.should have_content I18n.t('bike_statuses.views.index.status.not_available')      
      end
    end
    
    scenario "I can set my bike rent state and set daily, monthly and hourly costs for other users to see", :js => true do
      visit bike_path(@bike)
      
      within("#rent-box") do
        page.should have_content I18n.t('bike_statuses.views.index.status.not_available') 
        find('.reveals-rent').click        
      end
      
      within('#rent-modal') do
        page.select I18n.t('common_answers')[true], :from => 'bike_status_availability'
        fill_in 'bike_status_hour_cost', :with => "5"
        fill_in 'bike_status_month_cost', :with => "500"
        
        click_on I18n.t('actions.save')
      end
      
      within("#rent-box") do
        within('.hour_cost') do
          page.should have_content 5
        end
        
        within('.month_cost') do
          page.should have_content 500
        end
        
        find('.reveals-rent').click        
      end
      
      within('#rent-modal') do
        page.select I18n.t('common_answers')[true], :from => 'bike_status_availability'
        fill_in 'bike_status_hour_cost', :with => ""
        fill_in 'bike_status_month_cost', :with => ""
        
        click_on I18n.t('actions.save')
      end
      
      within("#rent-box") do
        page.should have_content I18n.t('bike_statuses.views.index.rent.costs_not_set')
        find('.reveals-rent').click        
      end
      
      within('#rent-modal') do
        page.select I18n.t('common_answers')[false], :from => 'bike_status_availability'
        click_on I18n.t('actions.save')
      end
      
      within("#rent-box") do
        page.should have_content I18n.t('bike_statuses.views.index.status.not_available') 
      end
      
    end
    
    scenario "I can set my bike sell price", :js => true do
      visit bike_path(@bike)
      
      within("#sell-box") do
        page.should have_content I18n.t('bike_statuses.views.index.status.not_available') 
        find('.reveals-sell').click        
      end
      
      within('#sell-modal') do
        page.select I18n.t('common_answers')[true], :from => 'bike_status_availability'
        click_on I18n.t('actions.save')
      end
      
      within("#sell-box") do
        page.should have_content I18n.t('bike_statuses.views.index.sell.price_not_set')
        find('.reveals-sell').click        
      end
      
      within('#sell-modal') do
        page.select I18n.t('common_answers')[true], :from => 'bike_status_availability'
        fill_in 'bike_status_price', :with => "12009"
        
        click_on I18n.t('actions.save')
      end
      
      within("#sell-box") do
        within('.value') do
          page.should have_content 12009
        end
        find('.reveals-sell').click        
      end
      
      within('#sell-modal') do
        page.select I18n.t('common_answers')[false], :from => 'bike_status_availability'
        click_on I18n.t('actions.save')
      end
      
      within("#sell-box") do
        page.should have_content I18n.t('bike_statuses.views.index.status.not_available') 
      end
    end
  end
  
end