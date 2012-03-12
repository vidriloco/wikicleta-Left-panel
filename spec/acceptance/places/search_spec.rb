#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Searching of places: ' do
  
  describe "There are three places registered around the city" do
    
    before(:each) do
      Factory(:museum)
      cinema=Factory(:cinema)
      transport=Factory(:transport_station)
      workshop=Factory(:workshop)
      restaurant=Factory(:restaurant)
      @popular = Factory(:popular_place, :name => "La Cebolla Morada", :category => restaurant)
      @accessible = Factory(:accessible_place, :category => transport)
      @recent = Factory(:recent_place, :category => workshop)
    end
    
    describe "given I visit the search page" do
    
      before(:each) do
        visit places_search_path
        sleep 4
      end
    
      it "should NOT find any place with name 'Casa Azul'", :js => true do
        fill_in "search_place_name", :with => "Casa Azul"
        #uncheck "search_place_map_enabled"
        click_on I18n.t('actions.search')
        
        current_path.should == places_search_path
        
        page.should have_content I18n.t('places.views.search.results.empty')
      end
    
      it "should find the place whose name is 'La Cebolla Morada'", :js => true do
        
        fill_in "search_place_name", :with => "La Cebolla Morada"
        page.should have_content I18n.t('places.views.search.suggestions.select_map_area')
        
        #uncheck "search_place_map_enabled"
        click_on I18n.t('actions.search')
        
        current_path.should == places_search_path
        
        #page.evaluate_script("$('#found-places').children().length;").should == 1
        page.evaluate_script("$('#l-places').children().length;").should == 1
        within("#place-#{@popular.id}") do
          place_view_spec(@popular)
        end
      end
    
      it "should find all the registered places given they all share common keywords on their description searching in all the city", :js => true do
        page.execute_script('mapWrap.simulatePinPointSearch({lat: 19.385119, lon: -99.128609, zoom: 10 });')
        fill_in "search_place_description", :with => "Una decripción para"
        #uncheck "search_place_map_enabled"
        click_on I18n.t('actions.search')
        
        current_path.should == places_search_path
        
        #page.evaluate_script("$('#found-places').children().length;").should == 3
        page.evaluate_script("$('#l-places').children().length;").should == 3
        [@popular, @accessible, @recent].each do |place|
          simple_description_block_for(place)
        end
        
      end 
    
      it "should find the places wich belong to the categories 'Restaurant' and 'Workshop' searching in all the city", :js => true do
        page.execute_script('mapWrap.simulatePinPointSearch({lat: 19.385119, lon: -99.128609, zoom: 11 });')
        find('.cats').uncheck('museum')
        find('.cats').uncheck('cinema')
        find('.cats').uncheck('transport_station')
        #uncheck "search_place_map_enabled"
        
        click_on I18n.t('actions.search')
        # page.should have_content I18n.t('places.views.search_results.title')
        #page.evaluate_script("$('#found-places').children().length;").should == 2
        page.evaluate_script("$('#l-places').children().length;").should == 2
        
        [@popular, @recent].each do |place|
          simple_description_block_for(place)
        end
      end
    
      it "should only find one place given it's searched by name 'La Cebolla Morada' with 'Restaurant' as category and description 'Una decripción para un'", :js => true do
        fill_in "search_place_name", :with => "La Cebolla Morada"
        find('.cats').uncheck('museum')
        find('.cats').uncheck('cinema')
        find('.cats').uncheck('transport_station')
        #uncheck "search_place_map_enabled"
        
        fill_in "search_place_description", :with => "Una decripción para un"
        
        click_on I18n.t('actions.search')
        page.should have_content I18n.t('places.views.search.results.some.one')
        #page.evaluate_script("$('#found-places').children().length;").should == 1
        page.evaluate_script("$('#l-places').children().length;").should == 1
        
        [@popular].each do |place|
          simple_description_block_for(place)
        end
      end
    
      it "should find two places that are inside a small quadrant of the map", :js => true do
        page.execute_script('mapWrap.simulatePinPointSearch({lat: 19.385119, lon: -99.128609, zoom: 13 });')
        click_on I18n.t('actions.search')
        #page.evaluate_script("$('#found-places').children().length;").should == 2
        page.evaluate_script("$('#l-places').children().length;").should == 2
        page.should have_content I18n.t('places.views.search.results.some.other', :count => 2)
        [@accessible, @popular].each do |place|
          simple_description_block_for(place)
        end
      end
    
      it "should find all the places given the selected map area contains all the registered ones", :js => true do
        page.execute_script('mapWrap.simulatePinPointSearch({lat: 19.371397404, lon: -99.136848449, zoom: 12 });')
        click_on I18n.t('actions.search')
        #page.evaluate_script("$('#found-places').children().length;").should == 3
        page.evaluate_script("$('#l-places').children().length;").should == 3
        
        [@accessible, @popular, @recent].each do |place|
          simple_description_block_for(place)
        end
      end
    
      it "should not find 'La Cebolla Morada' if the map is not containing it", :js => true do
        page.execute_script('mapWrap.simulatePinPointSearch({lat: 19.359534623, lon: -99.13620471, zoom: 15 });')
        fill_in "search_place_name", :with => "La Cebolla Morada"
        click_on I18n.t('actions.search')
        
        #page.evaluate_script("$('#found-places').children().length;").should == 0
        page.evaluate_script("$('#l-places').children().length;").should == 0
      end
    
    end
  end
  
  def simple_description_block_for(place)
    within("#place-#{place.id}") do
      place_view_spec(place)
    end
  end
end