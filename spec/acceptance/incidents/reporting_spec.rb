#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Reporting bike incidents:" do
  
  before(:each) do
    @chain = FactoryGirl.create(:bike_item)
  end
  
  scenario "cannot add an incident report which lacks required fields", :js => true do
    visit new_map_incident_path
    click_on I18n.t('actions.save')
    
    page.should have_content I18n.t('actions.verify_fields_on_red')
  end
  
  describe "anonymously" do
    
    scenario "can see the main menu for adding an incident" do
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.anonymously')
      
      page.should have_content I18n.t('incidents.new.reporting.invitation')
      find_link I18n.t('actions.sessions.first_person.start').downcase
    end
    
    scenario "can add a stolen bike report", :js => true do
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.anonymously')
      
      fill_in "incident_description", :with => "My bike was sucked by a black hole"
      select Incident.humanized_kind_for(:theft), :from => "incident_kind"
      check "incident_complaint_issued"
      select @chain.name, :from => "incident_bike_item_id"
      fill_in "incident_bike_description", :with => "My blue giant bike"
      
      simulate_click_on_map({:lat => 19.4000762084, :lon => -99.265484})
      
      click_on I18n.t('actions.save')
      
      page.current_path.should == map_incidents_path
      page.should have_content I18n.t('incidents.create.saved')
    end
    
    scenario "can add a violent stolen bike report", :js => true do
      
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.anonymously')
      
      fill_in "incident_description", :with => "My bike was taken away from me by a guy with a knife"
      select Incident.humanized_kind_for(:assault), :from => "incident_kind"
      check "incident_complaint_issued"
      
      fill_in "incident_bike_description", :with => "My blue giant bike"
      simulate_click_on_map({:lat => 19.4000762084, :lon => -99.265484})
      
      click_on I18n.t('actions.save')
      
      page.current_path.should == map_incidents_path
      page.should have_content I18n.t('incidents.create.saved')
    end
    
    scenario "can add an accident report", :js => true do
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.anonymously')
      
      fill_in "incident_description", :with => "My bike wheel was broken by a car"
      select Incident.humanized_kind_for(:accident), :from => "incident_kind"
      uncheck "incident_complaint_issued"
      
      simulate_click_on_map({:lat => 19.1300062084, :lon => -99.245484})
      
      click_on I18n.t('actions.save')
      
      page.current_path.should == map_incidents_path
      page.should have_content I18n.t('incidents.create.saved')
    end
    
    scenario "can add an regulation infraction report", :js => true do
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.anonymously')
      
      fill_in "incident_description", :with => "My bike wheel was broken by a car"
      select Incident.humanized_kind_for(:regulation_infraction), :from => "incident_kind"
      uncheck "incident_complaint_issued"
      
      simulate_click_on_map({:lat => 19.2000762084, :lon => -99.265484})
      
      click_on I18n.t('actions.save')
      
      page.current_path.should == map_incidents_path
      page.should have_content I18n.t('incidents.create.saved')
    end    
  end
  
  
  describe "being logged in" do
  
    before(:each) do
      @user=FactoryGirl.create(:user)
      login_with(@user)
    end
  
    scenario "can add a stolen bike report", :js => true do
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.as', :account => @user.username)
      
      fill_in "incident_description", :with => "My bike was sucked by a black hole"
      select Incident.humanized_kind_for(:theft), :from => "incident_kind"
      check "incident_complaint_issued"
      select @chain.name, :from => "incident_bike_item_id"
      fill_in "incident_bike_description", :with => "My bike was blue and fast"
      
      simulate_click_on_map({:lat => 19.4000762084, :lon => -99.265484})
      
      click_on I18n.t('actions.save')
      
      page.current_path.should == map_incidents_path
      page.should have_content I18n.t('incidents.create.saved')
    end
    
    scenario "can add a violent stolen bike report", :js => true do
      
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.as', :account => @user.username)
      
      fill_in "incident_description", :with => "My bike was taken away from me by a guy with a knife"
      select Incident.humanized_kind_for(:assault), :from => "incident_kind"
      check "incident_complaint_issued"
      fill_in "incident_bike_description", :with => "My bike was blue and fast"
      
      simulate_click_on_map({:lat => 19.4000762084, :lon => -99.265484})
      
      click_on I18n.t('actions.save')
      
      page.current_path.should == map_incidents_path
      page.should have_content I18n.t('incidents.create.saved')
    end
    
    scenario "can add an accident report", :js => true do
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.as', :account => @user.username)
      
      fill_in "incident_description", :with => "My bike wheel was broken by a car"
      select Incident.humanized_kind_for(:accident), :from => "incident_kind"
      uncheck "incident_complaint_issued"
      
      simulate_click_on_map({:lat => 19.1300062084, :lon => -99.245484})
      
      click_on I18n.t('actions.save')
      
      page.current_path.should == map_incidents_path
      page.should have_content I18n.t('incidents.create.saved')
    end
    
    scenario "can add an regulation infraction report", :js => true do
      visit new_map_incident_path
      
      page.should have_content I18n.t('incidents.new.title')
      page.should have_content I18n.t('incidents.new.kind.bike')
      page.should have_content I18n.t('incidents.new.reporting.as', :account => @user.username)
      
      fill_in "incident_description", :with => "My bike wheel was broken by a car"
      select Incident.humanized_kind_for(:regulation_infraction), :from => "incident_kind"
      uncheck "incident_complaint_issued"
      simulate_click_on_map({:lat => 19.2000762084, :lon => -99.265484})
      
      click_on I18n.t('actions.save')
      
      page.current_path.should == map_incidents_path
      page.should have_content I18n.t('incidents.create.saved')
    end
  
  end
  
end