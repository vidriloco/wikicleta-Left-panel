#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Evaluation of places: ' do
  
  describe "having loaded evaluations for workshops" do
    
    before(:each) do
      @workshops = Factory.create(:workshop)
      register_evaluation_form_for(@workshops)
    end
    
    describe "with a place within that category" do
    
      before(:each) do
        @user = Factory(:user)
        @taller = Factory.build(:recent_place, :category => @workshops)
        @taller.add_recommender(@user, [:owner])
        @taller.save    
      end
  
      describe "If I am logged-in" do
    
        before(:each) do
          login_with(@user)
        end
    
        scenario "when visiting the place I can write my first evaluation of it and can change it after", :js => true do
          visit place_path(@taller)
          evaluation_review_for(@taller, 0)
          within('.header') do
            page.should have_content I18n.t('places.subviews.show.evaluations.new_or_edit.title')
          end
      
          meta_survey_view_form_for(@workshops)
      
          within('.evaluation-form') do
            choose "Buena"
            choose "Poca"
            choose "Económico"
            choose "No lo son"

            click_on I18n.t('actions.save')
          end
          sleep 2
      
          page.evaluate_script("$('.count-1').length").should == 4;
          page.evaluate_script("$('#'+$('.count-1')[0].id).text().trim()").should == "Buena"
          page.evaluate_script("$('#'+$('.count-1')[1].id).text().trim()").should == "Poca"
          page.evaluate_script("$('#'+$('.count-1')[2].id).text().trim()").should == "Económico"
          page.evaluate_script("$('#'+$('.count-1')[3].id).text().trim()").should == "No lo son"  
          
          evaluation_review_for(@taller, 1, :re_evaluate)
          
          within('.header') do
            page.should have_content I18n.t('places.subviews.show.evaluations.new_or_edit.title')
          end
          
          meta_survey_view_form_for(@workshops)
      
          within('.evaluation-form') do
            choose "Regular"
            choose "Mucha"
            choose "Muy caro"
            choose "Son amables"

            click_on I18n.t('actions.save')
          end
          sleep 2
          
          page.evaluate_script("$('.count-1').length").should == 4;
          page.evaluate_script("$('#'+$('.count-1')[0].id).text().trim()").should == "Regular"
          page.evaluate_script("$('#'+$('.count-1')[1].id).text().trim()").should == "Mucha"
          page.evaluate_script("$('#'+$('.count-1')[2].id).text().trim()").should == "Muy caro"
          page.evaluate_script("$('#'+$('.count-1')[3].id).text().trim()").should == "Son amables"
          
          evaluation_review_for(@taller, 1, :re_evaluate)
        end
        
        scenario "should not let me register an evaluation if I do not answer all the questions", :js => true do
          visit place_path(@taller)
          evaluation_review_for(@taller, 0)
          within('.header') do
            page.should have_content I18n.t('places.subviews.show.evaluations.new_or_edit.title')
          end
      
          meta_survey_view_form_for(@workshops)
      
          within('.evaluation-form') do
            choose "Económico"
            choose "No lo son"

            click_on I18n.t('actions.save')
          end
          sleep 2
          
          page.should have_content I18n.t('places.subviews.show.evaluations.validations.errors.missing_answers')
        end
        
        scenario "should not let me re-register an evaluation with not all answers answered", :js => true do
          visit place_path(@taller)
          evaluation_review_for(@taller, 0)
          within('.header') do
            page.should have_content I18n.t('places.subviews.show.evaluations.new_or_edit.title')
          end
      
          meta_survey_view_form_for(@workshops)
      
          within('.evaluation-form') do
            choose "Buena"
            choose "Poca"
            choose "Económico"
            choose "No lo son"

            click_on I18n.t('actions.save')
          end
          sleep 2
      
          page.evaluate_script("$('.count-1').length").should == 4;
          page.evaluate_script("$('#'+$('.count-1')[0].id).text().trim()").should == "Buena"
          page.evaluate_script("$('#'+$('.count-1')[1].id).text().trim()").should == "Poca"
          page.evaluate_script("$('#'+$('.count-1')[2].id).text().trim()").should == "Económico"
          page.evaluate_script("$('#'+$('.count-1')[3].id).text().trim()").should == "No lo son"  
          
          evaluation_review_for(@taller, 1, :re_evaluate)
          
          within('.evaluation-form') do
            choose "Económico"
            choose "No lo son"

            click_on I18n.t('actions.save')
          end
          sleep 2
          
          page.should have_content I18n.t('places.subviews.show.evaluations.validations.errors.missing_answers')
        end
        
      end
  
      describe "If I am not logged-in" do
    
        scenario "when visiting the place I should see it's evaluations BUT should NOT be allowed to evaluate it", :js => true do
          visit place_path(@taller)
      
          evaluation_review_for(@taller, 0)
          page.should have_content I18n.t('places.messages.error.login_required', :action => I18n.t('places.messages.error.complements.evaluate'))
        end
    
      end
    end
  end
end

def evaluation_review_for(place, evaluations_count, eval_status=:evaluate)
  within('.evaluation') do
    meta_survey_view_show place.category.meta_survey
  end

  within('.header') do
    page.should have_content I18n.t('places.subviews.show.evaluations.show.title')
    page.should have_content evaluations_count
    if evaluations_count == 1
      page.should have_content I18n.t('places.subviews.show.evaluations.show.count.one')
    else
      page.should have_content I18n.t('places.subviews.show.evaluations.show.count.other')
    end
  
    if eval_status.eql?(:re_evaluate)
      click_link I18n.t('places.common_actions.re_evaluate')
    else
      click_link I18n.t('places.common_actions.evaluate')
    end
  end
end

def register_evaluation_form_for(category)
  login_with(Factory(:admin), new_admin_session_path)
  click_link MetaSurvey.model_name.human.pluralize

  click_link I18n.t('actions.new.fem')
  select(category.name, :from => "category")
  path = File.join(Rails.root, "spec", "resources", "evaluations", "talleres.yml")

  attach_file("descriptor_file", path)
  click_on I18n.t('actions.save')
end

def meta_survey_view_show(meta_survey)
  @taller.category.meta_survey.meta_questions.each do |meta_question|
    meta_question_component_show(meta_question)
  end
end

def meta_question_component_show(meta_question)
  within("#meta-question-#{meta_question.id}") do
    
    within(".title") do
      page.should have_content meta_question.title
    end

    meta_question.meta_answer_items.each do |meta_answer_item|
      meta_answer_item_component_show(meta_answer_item)
    end
  end
end

def meta_answer_item_component_show(meta_answer_item)
  within(".options") do
    within("#meta-answer-item-#{meta_answer_item.id}") do
      page.should have_content meta_answer_item.human_value
    end
  end
end

def meta_survey_view_form_for(object)
  within(".evaluation-form") do
    object.meta_survey.meta_questions.each do |meta_question|
      meta_question_component_form(meta_question)
    end
  end
end

def meta_question_component_form(meta_question)
  within("#meta-question-#{meta_question.id}") do
    within(".number") do
      page.should have_content meta_question.order_identifier
    end
    
    within(".title") do
      page.should have_content meta_question.title
    end
    
    meta_question.meta_answer_items.each do |meta_answer_item|
      meta_answer_item_component_form(meta_answer_item)
    end
  end
end

def meta_answer_item_component_form(meta_answer_item) 
  within(".options") do
    within("#meta-answer-item-#{meta_answer_item.id}") do
      
      within(".value") do
        page.should have_content meta_answer_item.human_value
      end
    end
  end
end