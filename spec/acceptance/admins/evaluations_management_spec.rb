# encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Management of evaluations:" do
  
  describe "Having logged-in" do
    
    before(:each) do
      @admin = Factory(:admin)
      login_with(@admin, new_admin_session_path)
      
      @workshop = Factory(:workshop)
    end
    
    scenario "should let me add a new evaluation survey" do
      click_link MetaSurvey.model_name.human.pluralize
      current_path.should == admins_evaluations_index_path
    
      page.should have_content MetaSurvey.model_name.human.pluralize
      page.should have_content I18n.t('meta_survey.views.index.empty')
    
      click_link I18n.t('actions.new.fem')
      current_path.should == admins_evaluations_new_path
      page.should have_content I18n.t('meta_survey.views.new.title')
      
      select(@workshop.name, :from => "category")
      path = File.join(Rails.root, "spec", "resources", "evaluations", "talleres.yml")
      attach_file("descriptor_file", path)
      click_on I18n.t('actions.save')
    
      current_path.should == admins_evaluations_index_path
            
      within("##{MetaSurvey.first.id}-ms") do
        page.should have_content I18n.t('meta_survey.views.show.fields.category')
        page.should have_content @workshop.name
      
        page.should have_content(MetaSurvey.first.name)
    
        page.should have_content I18n.t('meta_survey.views.show.fields.number_of_questions')
        page.should have_content(4)
    
        find_link I18n.t('meta_survey.views.index.show_questions')
      end
    end
  end
end