#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Listing bike incidents:" do
  
  before(:each) do
    @reporter = Factory(:user)
    @accident = Factory(:accident, :user => @reporter)
    @theft = Factory(:theft, :user => @reporter, :complaint_issued => false)
    @assault = Factory(:assault)
    @regulation_infraction = Factory(:regulation_infraction)
  end
  
  scenario "when visiting the incidents index I should see the status of all incidents" do
    visit incidents_path
    
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
    visit incidents_path
    
    page.find("#itemlist").should_not be_visible
    page.find("#submenu").should be_visible
    click_link I18n.t('incidents.index.numbers.total.other', :count => 4)
    
    page.find("#submenu").should_not be_visible
    page.find("#itemlist").should be_visible
    
    within('.incidents') do
      click_link I18n.t('incidents.index.numbers.assault.one')
      page.evaluate_script("$('##{@assault.id}').siblings('.item:hidden').length;").should == 3
      item_on_list(@assault)
      
      click_link I18n.t('incidents.index.numbers.theft.one')
      page.evaluate_script("$('##{@theft.id}').siblings('.item:hidden').length;").should == 3
      item_on_list(@theft, @reporter)
      
      click_link I18n.t('incidents.index.numbers.accident.one')
      page.evaluate_script("$('##{@accident.id}').siblings('.item:hidden').length;").should == 3
      item_on_list(@accident, @reporter)
      
      click_link I18n.t('incidents.index.numbers.regulation_infraction.one')
      page.evaluate_script("$('##{@regulation_infraction.id}').siblings('.item:hidden').length;").should == 3
      item_on_list(@regulation_infraction)
            
      find('.close-button').click
    end
    
    page.find("#submenu").should be_visible
    page.find("#itemlist").should_not be_visible
  end
  
  scenario "when visiting the incidents index I should be able to see the details of an incident", :js => true do
    visit incidents_path
    
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
      
      page.should have_content @accident.date_and_time.to_s(:short)
      
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