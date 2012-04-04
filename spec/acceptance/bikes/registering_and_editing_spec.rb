#encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Bike registration:" do
  
  describe "Given I am not registered" do
    
    scenario "should send me to the login page" do
      visit bikes_path
      click_on I18n.t('app.sections.bikes.subsections.new')
      
      page.current_path.should == new_user_session_path
    end
    
  end
  
  describe "When I am logged-in" do
    
    before(:each) do
      FactoryGirl.create(:bike_brand, :name => "Dahon")
      FactoryGirl.create(:bike_brand, :name => "Brompton")
      
      @user=FactoryGirl.create(:user)
      login_with(@user)
    end
    
    scenario "I can register a new bike" do
      visit new_bike_path
      
      fill_in 'bike_name', :with => "Hashi"
      fill_in 'bike_frame_number', :with => "9F2393DA"
      select I18n.t("bikes.categories.types.urban"), :from => "bike_kind"
      select "Dahon", :from => "bike_brand"
      fill_in 'bike_description', :with => "White dahon bike, super light and foldable"
      
      click_on I18n.t('bikes.actions.save')
      
      page.current_path.should == bike_path(Bike.last.id)
      
      page.should have_content "Hashi"
      page.should have_content "White dahon bike, super light and foldable"
    end
    
    scenario "I cannot register a new bike if fields to be answered are missing" do
      visit new_bike_path
      
      click_on I18n.t('bikes.actions.save')
      page.current_path.should == bikes_path
      
      page.should have_content I18n.t('bikes.views.errors.on_save')
    end
    
    describe "having registered a bike" do
    
      before(:each) do
        @bike=FactoryGirl.create(:bike, :user => @user)
      end
    
      scenario "I can modify it thereafter" do
        visit bike_path(@bike)
        click_on I18n.t('bikes.views.show.modify')
        page.current_path.should == edit_bike_path(@bike)
        
        fill_in 'bike_name', :with => "Diamante"
        fill_in 'bike_description', :with => "White bike, super light and foldable"
        click_on I18n.t('bikes.actions.update')
        page.current_path.should == bike_path(Bike.last.id)
        
        page.should have_content "Diamante"
        page.should have_content "White bike, super light and foldable"
      end
    end
    
    scenario "I cannot modify a bike not owned by me" do
      @bike=FactoryGirl.create(:bike, :name => "Red bike", :user => FactoryGirl.create(:pancho))
      
      visit bike_path(@bike)
      page.should_not have_content I18n.t('bikes.views.show.modify')
    end
  end
  
end