#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Filtering bike incidents:" do
    
  before(:each) do
    @reporter = FactoryGirl.create(:user)
    @accident = FactoryGirl.create(:accident, :user => @reporter)
    @theft = FactoryGirl.create(:theft, :user => @reporter, :complaint_issued => false)
    @assault = FactoryGirl.create(:assault, :user => @reporter)
    @old_incident = FactoryGirl.create(:assault, :date => Date.today-3.years, :user => @reporter)
  end
  
  scenario "should let me filter by thefts, regulation infractions and assaults on all dates", :js => true do
    visit map_incidents_path
    
    click_link I18n.t('app.sections.incidents.subsections.search')
    sleep 3
    page.should have_content I18n.t('incidents.views.filtering.title')
    
    select I18n.t('incidents.views.filtering.fields.date.all'), :from => "incident_range_date"
    click_on I18n.t('actions.accept')
    
    stat_for('#assault', 2, I18n.t('incidents.views.index.numbers.assault.other'))
    stat_for('#theft', 1, I18n.t('incidents.views.index.numbers.theft.one'))
    stat_for('#accident', 1, I18n.t('incidents.views.index.numbers.accident.one'))
    stat_for('#regulation_infraction', 0, I18n.t('incidents.views.index.numbers.regulation_infraction.other'))
  end
  
  scenario "should let me filter by all types and by complaint issued", :js => true do
    visit map_incidents_path
    click_link I18n.t('app.sections.incidents.subsections.search')
    sleep 3
    select I18n.t('common_answers')[false], :from => "incident_complaint_issued"
    select I18n.t('incidents.views.filtering.fields.date.all'), :from => "incident_range_date"
    
    click_on I18n.t('actions.accept')
    
    stat_for('#assault', 0, I18n.t('incidents.views.index.numbers.assault.other'))
    stat_for('#theft', 1, I18n.t('incidents.views.index.numbers.theft.one'))
    stat_for('#accident', 0, I18n.t('incidents.views.index.numbers.accident.other'))
    stat_for('#regulation_infraction', 0, I18n.t('incidents.views.index.numbers.regulation_infraction.other'))
  end
  
  scenario "should let me filter by accidents, thefts and assaults with a complaint issued and ocurring during the last week", :js => true do
    visit map_incidents_path
    click_link I18n.t('app.sections.incidents.subsections.search')
    sleep 3
    select I18n.t('common_answers')[true], :from => "incident_complaint_issued"
    select I18n.t('incidents.views.filtering.fields.date.last_week'), :from => "incident_range_date"
    
    click_on I18n.t('actions.accept')
    
    stat_for('#assault', 0, I18n.t('incidents.views.index.numbers.assault.other'))
    stat_for('#theft', 0, I18n.t('incidents.views.index.numbers.theft.other'))
    stat_for('#accident', 1, I18n.t('incidents.views.index.numbers.accident.one'))
    stat_for('#regulation_infraction', 0, I18n.t('incidents.views.index.numbers.regulation_infraction.other'))
  end
  
  describe "If I select to filter results to visible map area only" do
    
    before(:each) do
      FactoryGirl.create(:regulation_infraction, 
        :date => Date.today-10.years, 
        :coordinates => Point.from_lon_lat(-99.0000, 19.1000, 4326))
    end
    
    it "should show only one", :js => true do
      visit map_incidents_path
      click_link I18n.t('app.sections.incidents.subsections.search')
      sleep 5
      
      select I18n.t('incidents.views.filtering.fields.date.all'), :from => "incident_range_date"  
      check "incident_map_enabled"
      select I18n.t('common_answers')[true], :from => "incident_complaint_issued"
      
      page.execute_script('section.getMap().simulatePinPointSearch({lat: 19.1000, lon: -99.0000, zoom: 15});')
      
      within('.search') do
        click_on I18n.t('actions.accept')
      end
      
      stat_for('#assault', 0, I18n.t('incidents.views.index.numbers.assault.other'))
      stat_for('#theft', 0, I18n.t('incidents.views.index.numbers.theft.other'))
      stat_for('#accident', 0, I18n.t('incidents.views.index.numbers.accident.other'))
      stat_for('#regulation_infraction', 1, I18n.t('incidents.views.index.numbers.regulation_infraction.one'))
    end
    
  end
  
end

def stat_for(type, number, text)
  
  within("#floating #{type}") do
    within('.number') do
      page.should have_content number
    end
    within('.text') do
      page.should have_content text
    end
    
  end
  
end