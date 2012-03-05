#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Listing and filtering bike incidents:" do
  
  before(:each) do
    @reporter = Factory(:user)
    @accident = Factory(:accident, :user => @reporter)
    @theft = Factory(:theft, :user => @reporter, :complaint_issued => false)
    @assault = Factory(:assault)
    @regulation_infraction = Factory(:regulation_infraction, :date_and_time => Date.today-1.month)
  end
  
  describe "Listing: " do
    scenario "when visiting the incidents index I should see the status of all incidents" do
      visit map_incidents_path
    
      page.should have_content I18n.t('incidents.index.title')
      page.should have_content I18n.t('incidents.index.kind.bike')
    
      find_link I18n.t('incidents.index.new')
    
      find_link I18n.t('incidents.index.numbers.total.other', :count => 4)
      find_link I18n.t('incidents.index.search')
    
      page.should have_content I18n.t('incidents.index.numbers.assault.one')
      page.should have_content I18n.t('incidents.index.numbers.theft.one')
      page.should have_content I18n.t('incidents.index.numbers.accident.one')
      page.should have_content I18n.t('incidents.index.numbers.regulation_infraction.one')
    end
  
    scenario "when visiting the incidents index I should see the listing of them after clicking totals", :js => true do
      visit map_incidents_path
    
      page.find("#itemlist").should_not be_visible
      page.find("#submenu").should be_visible
      click_link I18n.t('incidents.index.numbers.total.other', :count => 4)
    
      page.find("#submenu").should_not be_visible
      page.find("#itemlist").should be_visible
    
      within('.incidents') do
        
        click_link I18n.t('incidents.index.numbers.assault.one')
        within(".assault") do
          item_on_list(@assault)
        end
        
        click_link I18n.t('incidents.index.numbers.theft.one')
        within(".theft") do
          item_on_list(@theft, @reporter)
        end
        
        click_link I18n.t('incidents.index.numbers.accident.one')
        within(".accident") do
          item_on_list(@accident, @reporter)
        end
        
        click_link I18n.t('incidents.index.numbers.regulation_infraction.one')
        within(".regulation_infraction") do
          item_on_list(@regulation_infraction)
        end
            
        find('.close-button').click
      end
    
      page.find("#submenu").should be_visible
      page.find("#itemlist").should_not be_visible
    end
  
    scenario "when visiting the incidents index I should be able to see the details of an incident", :js => true do
      visit map_incidents_path
    
      click_link I18n.t('incidents.index.numbers.total.other', :count => 4)
    
      click_link I18n.t('incidents.index.numbers.assault.one')
      within("##{@assault.id}") do
        click_link I18n.t('incidents.index.list.item.details')
      end
    
      within("#itemdetails") do
        page.should have_content @assault.humanized_kind
        page.should have_content @assault.description
        page.should have_content I18n.t('incidents.index.list.item.reporter.anonymous')
        page.should have_content I18n.t('incidents.index.list.item.complaint_issued')[true]
      
        page.should have_content @assault.date_and_time.to_s(:short)
      
        I18n.t('activerecord.attributes.incident.attacher_used')
      
        find(".back-button").click
      end
    
      click_link I18n.t('incidents.index.numbers.theft.one')
      within("##{@theft.id}") do
        click_link I18n.t('incidents.index.list.item.details')
      end
    
      within("#itemdetails") do
        page.should have_content @theft.humanized_kind
        page.should have_content @theft.description
      
        page.should have_content I18n.t('activerecord.attributes.incident.attacher_used')
        page.should have_content @theft.bike_item.name
      
        page.should have_content I18n.t('incidents.index.list.item.reporter.user', :user => @theft.user.username)
        page.should have_content I18n.t('incidents.index.list.item.complaint_issued')[false]
      
        page.should have_content @assault.date_and_time.to_s(:short)
            
        find(".back-button").click
      end
    
      click_link I18n.t('incidents.index.numbers.accident.one')
      within("##{@accident.id}") do
        click_link I18n.t('incidents.index.list.item.details')
      end
    
      within("#itemdetails") do
        page.should have_content @accident.humanized_kind
        page.should have_content @accident.description
      
        page.should_not have_content I18n.t('activerecord.attributes.incident.attacher_used')
      
        page.should have_content I18n.t('incidents.index.list.item.reporter.user', :user => @accident.user.username)
        page.should have_content I18n.t('incidents.index.list.item.complaint_issued')[true]
      
        page.should have_content I18n.t('activerecord.attributes.incident.vehicle_identifier')
        page.should have_content @accident.vehicle_identifier
      
        page.should have_content @accident.date_and_time.to_s(:short)
            
        find(".back-button").click
      end
    
      click_link I18n.t('incidents.index.numbers.regulation_infraction.one')
      within("##{@regulation_infraction.id}") do
        click_link I18n.t('incidents.index.list.item.details')
      end
    
      within("#itemdetails") do
        page.should have_content @regulation_infraction.humanized_kind
        page.should have_content @regulation_infraction.description
      
        page.should_not have_content I18n.t('activerecord.attributes.incident.attacher_used')
      
        page.should have_content I18n.t('incidents.index.list.item.reporter.anonymous')
        page.should have_content I18n.t('incidents.index.list.item.complaint_issued')[true]
      
        page.should have_content I18n.t('activerecord.attributes.incident.vehicle_identifier')
        page.should have_content @accident.vehicle_identifier
            
        find(".back-button").click
      end
    
      within('#itemlist') do
        find(".close-button").click
      end
    
      page.find("#itemlist").should_not be_visible
      page.find("#itemdetails").should_not be_visible
    
      page.find("#submenu").should be_visible
    end
  end

  describe "Filtering: " do
    
    before(:each) do
      @old_incident = Factory(:assault, :date_and_time => Date.today-3.years)
    end
    
    scenario "should not let me search if I do not select a kind of incident", :js => true do
      visit map_incidents_path
      
      click_link I18n.t('incidents.index.search')
      
      within("#itemsfiltering") do
        select I18n.t('incidents.filtering.fields.date.all'), :from => "incident_range_date"
        click_on I18n.t('actions.accept')
      end
      
      find("#itemsfiltering").should be_visible
    end
    
    scenario "should let me refine the incidents appearing on the map", :js => true do
      visit map_incidents_path
      
      find_link I18n.t('incidents.index.numbers.total.other', :count => 5)
      stats_for(:accident => 1, :assault => 2, :theft => 1, :regulation_infraction => 1)
      
      click_link I18n.t('incidents.index.search')
      
      within("#itemsfiltering") do
        page.should have_content I18n.t('incidents.filtering.title')
        page.should have_content I18n.t('activerecord.attributes.incident.date_and_time')
        
        check "incident_type_theft"
        check "incident_type_regulation_infraction"
        check "incident_type_assault"
        select I18n.t('incidents.filtering.fields.date.all'), :from => "incident_range_date"
        click_on I18n.t('actions.accept')
      end
      
      find_link I18n.t('incidents.index.numbers.total.other', :count => 4)
      stats_for(:accident => 0, :assault => 2, :theft => 1, :regulation_infraction => 1)
      
      click_link I18n.t('incidents.index.search')
      
      within("#itemsfiltering") do
        select I18n.t('common_answers')[false], :from => "incident_complaint_issued"
        select I18n.t('incidents.filtering.fields.date.all'), :from => "incident_range_date"
        
        click_on I18n.t('actions.accept')
      end
      
      find_link I18n.t('incidents.index.numbers.total.one')
      stats_for(:accident => 0, :assault => 0, :theft => 1, :regulation_infraction => 0)
      
      click_link I18n.t('incidents.index.search')
      
      within("#itemsfiltering") do
        select I18n.t('common_answers')[true], :from => "incident_complaint_issued"
        check "incident_type_accident"
        check "incident_type_theft"
        check "incident_type_assault"
        
        select I18n.t('incidents.filtering.fields.date.last_week'), :from => "incident_range_date"
        click_on I18n.t('actions.accept')
      end
      
      find_link I18n.t('incidents.index.numbers.total.other', :count => 2)
      stats_for(:accident => 1, :assault => 1, :theft => 0, :regulation_infraction => 0)
    end
    
    describe "If I select to filter results to visible map area only" do
      
      before(:each) do
        Factory(:regulation_infraction, 
          :date_and_time => Date.today-10.years, 
          :coordinates => Point.from_lon_lat(-99.119725, 19.298197, 4326))
      end
      
      it "should show only one", :js => true do
        visit map_incidents_path
        
        page.execute_script('mapWrap.simulatePinPointSearch({lat: 19.298197, lon: -99.119725, zoom: 19 });')
        click_link I18n.t('incidents.index.search')
        
        within("#itemsfiltering") do
          check "incident_type_theft"
          check "incident_type_regulation_infraction"
          check "incident_type_assault"
          select I18n.t('incidents.filtering.fields.date.all'), :from => "incident_range_date"
          
          check "incident_map_enabled"
          click_on I18n.t('actions.accept')
        end
        
        find_link I18n.t('incidents.index.numbers.total.one')
        stats_for(:accident => 0, :assault => 0, :theft => 0, :regulation_infraction => 1)
      end
      
    end
    
  end
  
  describe "Deleting: " do
    
    before(:each) do
      login_with(@reporter)
    end
    
    scenario "Given I am logged in, and being the owner of an incident post, then I can delete it", :js => true do
      visit map_incidents_path
    
      click_link I18n.t('incidents.index.numbers.total.other', :count => 4)
      
      click_link I18n.t('incidents.index.numbers.accident.one')
      
      within("##{@accident.id}") do
        click_link I18n.t('incidents.index.list.item.details')
      end
      
      within("#itemdetails") do
        click_on I18n.t('actions.delete')
      end
      page.driver.browser.switch_to.alert.accept
      
      page.should have_content I18n.t('incidents.destroy.success')
      
      find_link I18n.t('incidents.index.numbers.total.other', :count => 3)
    end
    
  end
end

def stats_for(hash)
  within('#submenu .status') do
    within(".accident-s") do
      page.should have_content hash[:accident]
    end
    
    within(".theft-s") do
      page.should have_content hash[:theft]
    end
    
    within(".assault-s") do
      page.should have_content hash[:assault]
    end
    
    within(".regulation_infraction-s") do
      page.should have_content hash[:regulation_infraction]
    end
  end
end

def item_on_list(item, user=nil)
  within("##{item.id}") do
    if user.nil?
      page.should have_content I18n.t('incidents.index.list.item.reporter.anonymous')
    else
      page.should have_content I18n.t('incidents.index.list.item.reporter.user', :user => user.username)
    end
    page.should have_content item.description
    find_link I18n.t('incidents.index.list.item.details')
  end
end