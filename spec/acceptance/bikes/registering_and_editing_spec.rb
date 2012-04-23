#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Bike registration:" do
  
  scenario "when visiting the index page should display an empty listing message" do
    visit bikes_path
    
    page.should have_content I18n.t('bikes.views.index.empty.message')
    find_link I18n.t('bikes.views.index.empty.invite')
  end
  
  scenario "when visiting the most popular page it should display an empty listing message" do
    visit popular_bikes_path
    
    page.should have_content I18n.t('bikes.views.index.empty.message')
    find_link I18n.t('bikes.views.index.empty.invite')
  end
  
  describe "Given I am not registered" do
    
    scenario "should send me to the login page" do
      visit bikes_path
      click_on I18n.t('app.sections.bikes.subsections.new')
      
      page.current_path.should == new_user_session_path
    end
    
  end
  
  describe "Having some bikes registered" do
  
    before(:each) do
      specialized = FactoryGirl.create(:specialized)
      @bike = FactoryGirl.create(:bike, :bike_brand => specialized)
    end
    
    scenario "when visiting the index page should show the results", :js => true do
      visit bikes_path
      preview_for_bike(@bike)
    end
    
  
    describe "if I am logged-in" do
    
      before(:each) do
        @user=FactoryGirl.create(:user)
        @dahon = FactoryGirl.create(:dahon)
        login_with(@user)
      end
      
      describe "having a bike registered", :js => true do
        
        before(:each) do
          @another_bike = FactoryGirl.create(:bike, :user => @user, :bike_brand => @dahon)
        end
        
        scenario "when visiting the index page should show the results" do
          visit bikes_path
          preview_for_bike(@bike)
          preview_for_bike(@another_bike)
        end
        
        scenario "when visiting my bikes page should show only one" do
          visit mine_bikes_path
          preview_for_bike(@another_bike)
        end
        
      end
    
      scenario "I can register a new bike", :js => true do
        visit new_bike_path
      
        click_on I18n.t('bikes.actions.save')
        page.should have_content I18n.t('bikes.views.form.validations.name')
        fill_in 'bike_name', :with => "Hashi"
        
        fill_in 'bike_frame_number', :with => "9F2393DA"
        
        click_on I18n.t('bikes.actions.save')
        page.should have_content I18n.t('bikes.views.form.validations.kind')
        select I18n.t("bikes.categories.types.urban"), :from => "bike_kind"
        
        click_on I18n.t('bikes.actions.save')
        page.should have_content I18n.t('bikes.views.form.validations.bike_brand')
        select "Dahon", :from => "bike_bike_brand_id"
        
        click_on I18n.t('bikes.actions.save')
        page.should have_content I18n.t('bikes.views.form.validations.description')
        fill_in 'bike_description', :with => "White dahon bike, super light and foldable"
        
        fill_in 'bike_weight', :with => "8e"
        click_on I18n.t('bikes.actions.save')
        page.should have_content I18n.t('bikes.views.form.validations.weight')
        
        fill_in 'bike_weight', :with => "8."
        click_on I18n.t('bikes.actions.save')
        page.should have_content I18n.t('bikes.views.form.validations.weight')
        
        fill_in 'bike_weight', :with => "8.5"
        click_on I18n.t('bikes.actions.save')
      
        page.current_path.should == bike_path(Bike.last.id)
        
        page.should have_content "Hashi"
        page.should have_content "White dahon bike, super light and foldable"
        
        page.should have_content I18n.t('bikes.messages.saved')
      end
    
      scenario "I cannot register a new bike if fields to be answered are missing" do
        visit new_bike_path
      
        click_on I18n.t('bikes.actions.save')
        page.current_path.should == bikes_path
      
        page.should have_content I18n.t('bikes.views.errors.on_save')
      end
    
      describe "having registered a bike", :js => true do
    
        before(:each) do
          @bike=FactoryGirl.create(:bike, :user => @user)
        end
    
        scenario "I can modify it" do
          visit bike_path(@bike)
          click_on I18n.t('bikes.views.show.modify')
          page.current_path.should == edit_bike_path(@bike)
        
          fill_in "bike_name", :with => ""
          click_on I18n.t('bikes.actions.update')
          page.should have_content I18n.t('bikes.views.form.validations.name')
          fill_in 'bike_name', :with => "Diamante"
          
          fill_in 'bike_description', :with => ""
          click_on I18n.t('bikes.actions.update')
          
          page.should have_content I18n.t('bikes.views.form.validations.description')
          fill_in 'bike_description', :with => "White bike, super light and foldable"
          
          fill_in 'bike_weight', :with => "11e"
          click_on I18n.t('bikes.actions.update')
          page.should have_content I18n.t('bikes.views.form.validations.weight')

          fill_in 'bike_weight', :with => "11."
          click_on I18n.t('bikes.actions.update')
          page.should have_content I18n.t('bikes.views.form.validations.weight')

          fill_in 'bike_weight', :with => "11.5"
          click_on I18n.t('bikes.actions.update')
          
          page.current_path.should == bike_path(Bike.last.id)
        
          page.should have_content "Diamante"
          page.should have_content "White bike, super light and foldable"
          
          page.should have_content I18n.t('bikes.messages.updated')
        end
        
        scenario "I can delete it" do
          visit edit_bike_path(@bike)
          
          accept_confirmation_for do 
            click_on I18n.t('bikes.actions.delete')
          end
          
          page.should have_content I18n.t('bikes.messages.deleted')
        end
      end
    
      scenario "I cannot modify a bike not owned by me" do
        @bike=FactoryGirl.create(:bike, :name => "Red bike", :user => FactoryGirl.create(:pancho))
      
        visit bike_path(@bike)
        page.should_not have_content I18n.t('bikes.views.show.modify')
      end
      
    end
  end
  
end

def preview_for_bike(bike)
  within("##{bike.id}") do
    find_link bike.name
    page.should have_content bike.brand
  end
end