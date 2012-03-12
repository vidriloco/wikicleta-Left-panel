#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Commits: creation, modification and deletion of places' do
  
  before(:each) do
    @user=Factory(:user)
    Factory(:workshop)
    @restaurant = Factory(:restaurant)
    
    login_with(@user)
  end
  
  scenario "creating a new place with valid data", :js => true do
    visit new_place_path
      
    page.should have_content I18n.t('places.views.new.instruction')
    page.should have_content I18n.t('places.views.index.title')
    page.should have_content I18n.t('states.new')
    
    fill_in "place_name", :with => "Taller de Juvenal"
    fill_in "place_description", :with => "Uno de los talleres de bicis mas completos localizado al sur de la ciudad. Tienen refacciones para todo tipo de bicis, venden accesorios a buen costo y el servicio es generalmente rápido."
    fill_in "place_address", :with => "Delfin Madrigal #283 Col. Santo Domingo, Del. Coyoacán, D.F."
    select I18n.t('categories.all.workshop'), :from => "place_category_id"
    fill_in "place_twitter", :with => "juvenal"

    simulate_click_on_map({:lat => 19.42007620847585, :lon => -99.25376930236814})
    
    page.should_not have_content I18n.t('places.views.new.instruction')

    page.find('#coordinates_lat').value.should == "19.42007620847585"
    page.find('#coordinates_lon').value.should == "-99.25376930236814"
    
    click_on I18n.t('actions.save')
    
    current_path.should == place_path(Place.first)
    
  end
  
  describe "considering It was not me the one who registered an existant place" do
    
    before(:each) do
      user = Factory.build(:pipo)
      @place = Place.new_with_owner(FactoryGirl.attributes_for(:recent_place, :category => @restaurant, :name => "Goldtaco", :description => "Comida vegetariana", :twitter => "", :address => ""), user)
      @place.save
    end
    
    it "should not show me a modify button for changing it" do
      visit place_path(@place)
      page.should_not have_content I18n.t('places.views.show.edit')
    end
    
  end
  
  
  describe "given I registered a place" do
    
    before(:each) do
      @place = Place.new_with_owner(FactoryGirl.attributes_for(:recent_place, :category => @restaurant, :name => "Goldtaco", :description => "Comida vegetariana", :twitter => "", :address => ""), @user)
      @place.save
    end
    
    it "should allow me to modify it", :js => true do
      visit place_path(@place)
      click_link I18n.t('places.views.show.edit')
      
      current_path.should == edit_place_path(@place)
      
      page.should have_content I18n.t('places.views.index.title')
      page.should have_content I18n.t('states.edit')
      
      fill_in "place_name", :with => "Goldtaquito"
      fill_in "place_description", :with => "Comida vegetariana, bonita, barata y bien ubicada"
      fill_in "place_address", :with => "Eugenia esquina con Tajin #920, Col. Narvarte"
      fill_in "place_twitter", :with => "elgoldtaquito"
      
      simulate_click_on_map({:lat => 19.4000762084, :lon => -99.265484})
      click_on I18n.t('actions.update')
      current_path.should == place_path(@place)
      
      page.should have_content "Goldtaquito"
      page.should have_content "Comida vegetariana, bonita, barata y bien ubicada"
      page.should have_content "Eugenia esquina con Tajin #920, Col. Narvarte"
      page.should have_content "elgoldtaquito"
    end
    
    it "should not accept the changes if I provide non-valid data" do
      visit place_path(Place.first)
      click_link I18n.t('places.views.show.edit')
      
      fill_in "place_name", :with => ""
      click_on I18n.t('actions.update')
      current_path.should == place_path(@place)
      page.should have_content("#{I18n.t('app_name')} #{I18n.t("messages.save_failure", :element => Place.model_name.human)}")
      
    end
    
  end
  
  scenario "creating a new place with non-valid data" do
    visit new_place_path
    
    fill_in "place_twitter", :with => "@juvenal"
    
    click_on I18n.t('actions.save')
    current_path.should == places_path
    
    page.should have_content("#{I18n.t('app_name')} #{I18n.t("messages.save_failure", :element => Place.model_name.human)}")
    page.should have_content I18n.t('places.custom_validations.coordinates_missing')
    page.should have_content I18n.t('places.custom_validations.twitter_bad_format')
  end
  
end