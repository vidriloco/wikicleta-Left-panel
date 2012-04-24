#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Reporting bike incidents:", :js => true do  
  
  describe "anonymously" do
    
    scenario "sees a notification message due reporting as anonymous" do
      visit map_incidents_path
      
      click_link I18n.t('app.sections.incidents.subsections.new')
      sleep 3
      
      page.should have_content I18n.t('incidents.views.new.reporting.anonymously')
      page.should have_content I18n.t('actions.register_or_login')
      page.should have_content I18n.t('incidents.views.new.reporting.invitation')
    end
    
    scenario "can add a regulation infraction report" do
      visit map_incidents_path
      
      click_link I18n.t('app.sections.incidents.subsections.new')
      sleep 3
      
      page.should have_content I18n.t('incidents.views.new.title')
      
      click_on I18n.t('actions.save')
      
      page.should have_content I18n.t('incidents.views.new.form.validations.kind')
      select Bike.humanized_category_for(:incidents, :regulation_infraction), :from => "incident_kind"
      
      click_on I18n.t('actions.save')
      
      page.should have_content I18n.t('incidents.views.new.form.validations.range')
      select "13", :from => "incident_start_hour_4i"
      select "15", :from => "incident_final_hour_4i"
      
      click_on I18n.t('actions.save')
      
      page.should have_content I18n.t('incidents.views.new.form.validations.description')
      fill_in "incident_description", :with => "My bike wheel was broken by a car"*3
      
      uncheck "incident_complaint_issued"
      
      click_on I18n.t('actions.save')
      
      page.should have_content I18n.t('incidents.views.new.form.validations.coordinates')
      simulate_click_on_map({:lat => 19.2000762084, :lon => -99.265484})
      
      click_on I18n.t('actions.save')
      page.should have_content I18n.t('incidents.messages.saved')
      page.current_url.should == hash_link_for(map_incidents_path)
      
    end    
    
    scenario "cannot select other types of incidents" do
      visit map_incidents_path
      
      click_link I18n.t('app.sections.incidents.subsections.new')
      sleep 3
      page.should_not have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :accident))
      page.should_not have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :assault))
      page.should_not have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :theft))

    end
    
  end
  
  
  describe "being logged in" do
  
    before(:each) do
      @user=FactoryGirl.create(:user)
      login_with(@user)
    end
  
    describe "with a bike registered" do
      
      before(:each) do
        FactoryGirl.create(:bike, :user => @user)
      end
      
      scenario "should have all the other options" do
        visit map_incidents_path

        click_link I18n.t('app.sections.incidents.subsections.new')
        sleep 3
        
        page.should have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :assault))
        page.should have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :theft))
        page.should have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :regulation_infraction))
        page.should have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :accident))
      end
      
    end
    
    scenario "sees a notification message due reporting with no bikes" do
      visit map_incidents_path
      
      click_link I18n.t('app.sections.incidents.subsections.new')
      sleep 3
      
      page.should have_content I18n.t('incidents.views.new.reporting.with_no_bikes')
      page.should have_content I18n.t('bikes.actions.register')
    end
  
    scenario "cannot select other types of incidents" do
      visit map_incidents_path
      
      click_link I18n.t('app.sections.incidents.subsections.new')
      sleep 3
      
      page.should_not have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :accident))
      page.should_not have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :assault))
      page.should_not have_xpath select_option_for('incident_kind', Bike.humanized_category_for(:incidents, :theft))

    end
  end
  
end

def select_option_for(id, category_humanized)
  "//select[@id = '#{id}']/option[normalize-space(text()) = '#{category_humanized}']"
end