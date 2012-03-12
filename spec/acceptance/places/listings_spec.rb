require 'acceptance/acceptance_helper'

feature 'Places listing' do
  
  before(:each) do
    @user=Factory(:user)
  end
  
  describe "Having some places categories registered" do
    
    before(:each) do
      @workshop = Factory(:workshop)
      @restaurant = Factory(:restaurant)
      @t_station = Factory(:transport_station)
      @store = Factory(:store)
      Factory(:museum)
      Factory(:cinema)
    end
    
    describe "while logged in" do
    
      before(:each) do
        login_with(@user)
      end
      
      describe "having two places registered" do
      
        before(:each) do
          @places = []
          @places << Factory(:recent_place, :category => @t_station)
          @places << Factory(:popular_place, :category => @workshop)
        end
      
        scenario "visiting the main places page" do
          visit places_path
          find_link I18n.t('places.views.index.search')
          content_specs_with(@places)
        end
      end
      
      scenario "I can see the new place registration page" do
        visit places_path
        click_link I18n.t('places.views.index.new')
        current_path.should == new_place_path
      end
      
    end
  
    describe "while not logged in", :js => true do
      
      before(:each) do
        visit places_path
      end
      
      describe "having two places registered" do
      
        before(:each) do
          @places = []
          @places << Factory(:recent_place, :category => @t_station)
          @places << Factory(:popular_place, :category => @workshop)
        end
        
        scenario "visiting the main places page should show those places listed" do
          visit places_path
          
          find_link I18n.t('places.views.index.search')
          
          page.has_css?('#lgd_in').should be_false
          within('.lgd_in_not') do
            find_link I18n.t('places.views.index.registration_invitation')
          end
        
          content_specs_with(@places)
        end
        
      end
      
      scenario "I get asked to log-in when attempting to register a new place" do
        click_link I18n.t('places.views.index.new')
        current_path.should == new_user_session_path
      end
      
      describe "having two places with categories 'restaurant' 'store'" do
        
        before(:each) do
          @categorized = []
          Factory(:accessible_place, :name => "Zapata", :mobility_kindness_index => 9, :category => @t_station)
          
          @categorized << Factory(:accessible_place, :name => "Accesible", :category => @restaurant)
          Delorean.time_travel_to("1 month ago") do
            @categorized << Factory(:popular_place, :name => "Popular", :category => @store)
          end
        end
        
        scenario "when filtering by those categories should only show two and ordered" do
          
          select I18n.t('places.views.index.all'), :from => "l-params"

          find('.cats').uncheck('workshop')
          find('.cats').uncheck('museum')
          find('.cats').uncheck('cinema')
          find('.cats').uncheck('transport_station')
          page.evaluate_script("$('#l-places').children().length;").should == 2
          places_with_ordering_spec(@categorized)
        end
      end
      
      describe "having two places registered at different dates" do
      
        before(:each) do
          @recent = []
          Delorean.time_travel_to("1 month ago") do
            @recent << Factory(:accessible_place, :name => "Recent 1", :category => @t_station)
          end

          Delorean.time_travel_to("3 months ago") do
            @recent << Factory(:popular_place, :name => "Popular", :mobility_kindness_index => 5, :category => @store)
          end
        end
      
        scenario "when filtering by those more recent should show the most recent first" do
          select I18n.t('places.views.index.recent'), :from => "l-params"
          
          places_with_ordering_spec(@recent)
        end
      
      end
      
      describe "having two places wich have diff number of followers" do
      
        before(:each) do
          @popular = []
          @popular << Factory(:popular_place, :name => "Popular", :category => @restaurant, :recommendations_count => 20)
          @popular << Factory(:recent_place, :name => "Recent", :category => @t_station, :recommendations_count => 10)
        end
      
        scenario "visiting the main places page and show the most popular first" do
          select I18n.t('places.views.index.popular'), :from => "l-params"
        
          places_with_ordering_spec(@popular)
        end
      end
      
      describe "having two places with diff accessibility rankings" do
      
        before(:each) do
          @accessible = []
          @accessible << Factory(:accessible_place, :name => "Most Accessible", :mobility_kindness_index => 9, :category => @t_station)
          @accessible << Factory(:accessible_place, :name => "Accesible", :mobility_kindness_index => 6, :category => @restaurant)
        end
      
        scenario "visiting the main places page and show the most accessible first" do
          select I18n.t('places.views.index.accessible'), :from => "l-params"
        
          places_with_ordering_spec(@accessible)
        end
      end
    end
    
  end
end

def content_specs_with(places)  
  page.should have_content I18n.t('places.views.index.title')

  find_link I18n.t('places.views.index.new')

  within('.cats') do
    find_field "workshop"
    find_field "restaurant"
    find_field "transport_station"
    find_field "store"
    find_field "museum"
    find_field "cinema"
  end
  
  page.has_css?('#l-params')
  
  places.each do |place|
    within("#place-#{place.id}") do
      place_view_spec(place)
    end
  end

end

def places_with_ordering_spec(places)
  places.each_with_index do |place, index|
    within("#place-#{place.id}") do
      page.has_css?(".order-#{index}").should be_true
      place_view_spec(place)
    end
  end
end