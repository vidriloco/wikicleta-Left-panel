#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Listing of streets and it's data:" do
  
  scenario "I can see the main menu" do
    visit map_street_marks_path
    
    page.should have_content I18n.t('street_marks.index.title')
    page.should have_content I18n.t('street_marks.index.new')
    page.should have_content I18n.t('street_marks.index.kind.bike')
    page.should have_content I18n.t('street_marks.index.numbers.total.other', :count => 0)
  end
  
end