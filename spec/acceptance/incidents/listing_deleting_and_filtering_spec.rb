#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "For the incidents listed " do
  
  before(:each) do
    @reporter = FactoryGirl.create(:user)
    @accident = FactoryGirl.create(:accident, :user => @reporter)
    @theft = FactoryGirl.create(:theft, :user => @reporter, :complaint_issued => false)
    @assault = FactoryGirl.create(:assault, :user => @reporter)
  end
  
  describe "if I log-in" do
    
    before(:each) do
      login_with(@reporter)
    end
    
    scenario "can delete an incident I posted", :js => true do
      visit map_incidents_path
      sleep 5
      click_on I18n.t('incidents.views.index.numbers.accident.one')
      sleep 5
      
      page.current_url.should == hash_link_for(map_incidents_path, 'accidents')

      page.execute_script("$('.kind-group ##{@accident.id}').click();")
      sleep 5
      page.current_url.should == hash_link_for(map_incidents_path, "accidents/#{@accident.id}")
      
      page.should have_content I18n.t('incidents.views.edit.destroy')

      accept_confirmation_for do
        click_link I18n.t('incidents.actions.delete')
      end
      
      find_link I18n.t('incidents.views.index.numbers.accident.other')
    end
    
  end
  
  scenario "if visiting the index page then I should see it's global category status", :js => true do
    visit map_incidents_path
    find_link I18n.t('incidents.views.index.numbers.assault.one')
    find_link I18n.t('incidents.views.index.numbers.theft.one')
    find_link I18n.t('incidents.views.index.numbers.accident.one')
    find_link I18n.t('incidents.views.index.numbers.regulation_infraction.other')
  end
  
  scenario "after clicking on a global category status with numbering zero I should see an empty list message", :js => true do
    visit map_incidents_path
    sleep 5
    click_on I18n.t('incidents.views.index.numbers.regulation_infraction.other')
    sleep 5
    
    page.should have_content I18n.t("incidents.views.index.listing.plural.regulation_infraction")
    page.should have_content I18n.t("incidents.views.index.empty")
    page.current_url.should == hash_link_for(map_incidents_path, 'regulation_infractions')
  end
  
  scenario "can review the description of an incident", :js => true do
    visit map_incidents_path
    sleep 5
    click_on I18n.t('incidents.views.index.numbers.theft.one')
    
    page.current_url.should == hash_link_for(map_incidents_path, 'thefts')
    
    page.execute_script("$('.kind-group ##{@theft.id}').click();")
    sleep 5
    page.current_url.should == hash_link_for(map_incidents_path, "thefts/#{@theft.id}")
        
    page.should have_content I18n.t("incidents.views.index.listing.singular.theft") 
    page.should_not have_content I18n.t('incidents.views.edit.destroy')
    page.should_not have_content I18n.t('incidents.actions.delete')
    click_link I18n.t('actions.back')
    page.current_url.should == hash_link_for(map_incidents_path, 'thefts')
  end
    
  describe "with an extra incident" do
  
    before(:each) do
      @regulation_infraction = FactoryGirl.create(:regulation_infraction, :date => Date.today-1.month, :user => @reporter)
      visit map_incidents_path
    end
  
    scenario "after clicking on it's global category status I should see it's list of incidents", :js => true do
      visit map_incidents_path
      sleep 5
      click_on I18n.t('incidents.views.index.numbers.regulation_infraction.one')
      sleep 5
      
      page.should have_content I18n.t("incidents.views.index.listing.plural.regulation_infraction")
      page.current_url.should == hash_link_for(map_incidents_path, 'regulation_infractions')
      click_link I18n.t('actions.close')
      page.current_url.should == hash_link_for(map_incidents_path)
    end
      
  end
end