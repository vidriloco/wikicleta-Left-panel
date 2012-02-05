#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Searching of places: ' do
  
  describe "There are three places registered around the city" do
    
    before(:each) do
      @popular = Factory(:popular_place, :name => "La Cebolla Morada")
      @accessible = Factory(:accessible_place)
      @recent = Factory(:recent_place)
    end
    
    describe "given I visit the search page" do
    
      before(:each) do
        visit places_search_path
      end
    
      it "should NOT find any place with name 'Casa Azul'" do
        fill_in "search_place_name", :with => "Casa Azul"
        uncheck "search_place_map"
        click_on I18n.t('actions.search')
        
        current_path.should == places_search_path
        page.should have_content I18n.t('places.views.search_results.title')
        
        page.should have_content I18n.t('places.views.search_results.nothing_found')
      end
    
      it "should find the place whose name is 'La Cebolla Morada'", :js => true do
        page.should have_content I18n.t('places.views.search.title')
        
        fill_in "search_place_name", :with => "La Cebolla Morada"
        page.should have_content I18n.t('places.views.search.suggestions.select_map_area')
        page.should have_content I18n.t('places.views.search.fields.consider_map_visible_area')
        
        uncheck "search_place_map"
        click_on I18n.t('actions.search')
        
        current_path.should == places_search_path
        page.should have_content I18n.t('places.views.search_results.title')
        
        page.evaluate_script("$('#found-places').children().length;").should == 1
        within("#place-#{@popular.id}") do
          place_view_spec(@popular)
          find_link I18n.t('places.common_actions.follow')
        end
      end
    
      it "should find all the registered places given they all share common keywords on their description", :js => true do
        page.should have_content I18n.t('places.views.search.title')
        
        fill_in "search_place_description", :with => "Una decripción para"
        uncheck "search_place_map"
        click_on I18n.t('actions.search')
        
        current_path.should == places_search_path
        page.should have_content I18n.t('places.views.search_results.title')
        
        page.evaluate_script("$('#found-places').children().length;").should == 3
        [@popular, @accessible, @recent].each do |place|
          simple_description_block_for(place)
        end
        
      end 
    
      it "should find the places wich belong to the categories 'Restaurant' and 'Workshop'"
    
      it "should only find one place given it's searched by name 'La Cebolla Morada' and it's category is 'Restaurant' and on it's description appears 'Una decripción para un'"
    
      it "should find two places that are inside a small quadrant of the map"
    
      it "should find all the places given the selected map area contains all the registered ones"
    
      it "should not find 'La Cebolla Morada' even though the map boundaries contain it"
    
    end
  end
  
  def simple_description_block_for(place)
    within("#place-#{place.id}") do
      place_view_spec(place)
      find_link I18n.t('places.common_actions.follow')
    end
  end
end