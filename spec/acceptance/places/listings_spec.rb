require 'acceptance/acceptance_helper'

feature 'Places listing' do
  
  before(:each) do
    @user=Factory(:user)
  end
  
  describe "categorized with some three places registered" do
    
    before(:each) do
      Factory(:workshop)
      @restaurant = Factory(:restaurant)
      @t_station = Factory(:transport_station)
      @store = Factory(:store)
      Factory(:museum)
      Factory(:cinema)
      
      
      @places = { :all => [], :recent => [], :accessible => [], :popular => [], :categorized => []}

      # A place is recent when it's creation date is within this week date
      recent_place = Factory(:recent_place, :name => "Recent", :mobility_kindness_index => 2, :category => @restaurant)
      @places[:all] << recent_place
      @places[:accessible] << recent_place
      @places[:categorized] << recent_place
      
      Delorean.time_travel_to("1 month ago") do
        # A place is considered accessible when it's mobility kindness index is greater than 7
        @places[:all] << Factory(:accessible_place, :name => "Accesible", :mobility_kindness_index => Random.new.rand(7..10), :category => @t_station)
        
      end
      @places[:accessible].insert(0,@places[:all].last)
      @places[:popular] = @places[:all]
      Delorean.time_travel_to("3 months ago") do
        # A place is popular depending on it's number of followers
        popular_place = Factory(:popular_place, :name => "Popular", :mobility_kindness_index => 5, :category => @store)
        popular_place.stub(:followers_count) { Random.new.rand(1..200) }
        @places[:all] << popular_place
        @places[:popular].insert(0, popular_place)
        @places[:categorized] << popular_place
      end
      @places[:recent] = @places[:all]
      @places[:accessible].insert(1, @places[:all].last)
      
      
    end
    
    describe "while logged in" do
    
      before(:each) do
        login_with(@user)
      end
    
      scenario "visiting the main places page" do
        visit places_path
        within('#side-box') do
          find_link I18n.t('places.views.index.search')
          
          page.has_css?('#lgd_in_not').should be_false
          within('.lgd_in') do
            find_link I18n.t('places.views.index.followed_by_me')
            find_link I18n.t('places.views.index.shared_by_me')
          end
        end
        content_specs_with(@places[:all])
        
      end
      
      scenario "I can see the new place registration page" do
        visit places_path
        within('#main-box') do
          click_link I18n.t('places.views.index.new')
          
          current_path.should == new_place_path
        end
        
      end
      
    end
  
    describe "while not logged in", :js => true do
      
      before(:each) do
        visit places_path
      end
      
      scenario "visiting the main places page" do
              
        within('#side-box') do
          find_link I18n.t('places.views.index.search')
          
          page.has_css?('#lgd_in').should be_false
          within('.lgd_in_not') do
            find_link I18n.t('places.views.index.registration_invitation')
          end
        end
        
        content_specs_with(@places[:all])
    
      end
      
      scenario "I get asked to log-in" do
        
        within('#main-box') do
          click_link I18n.t('places.views.index.new')
          
          current_path.should == new_user_session_path
        end
        
      end
      
      scenario "visiting the main places page filtering by place category" do
        within('#main-box') do
          select I18n.t('places.views.index.all'), :from => "l-params"

          find('.cats').uncheck('workshop')
          find('.cats').uncheck('museum')
          find('.cats').uncheck('cinema')
          find('.cats').uncheck('transport_station')
                    
          page.evaluate_script("$('#l-places').children().length;").should == 2
          places_with_ordering_spec(@places[:categorized])
        end
      end
      
      scenario "visiting the main places page and show the most recent first" do
        within('#main-box') do
          select I18n.t('places.views.index.recent'), :from => "l-params"
          
          places_with_ordering_spec(@places[:recent])
        end
      end
      
      scenario "visiting the main places page and show the most popular first" do
        within('#main-box') do
          select I18n.t('places.views.index.popular'), :from => "l-params"
          
          places_with_ordering_spec(@places[:popular])
        end
      end
      
      scenario "visiting the main places page and show the most accessible first" do
        within('#main-box') do
          select I18n.t('places.views.index.accessible'), :from => "l-params"
          
          places_with_ordering_spec(@places[:accessible])
        end
      end
    end
    
  end
end

def content_specs_with(places)
  page.has_css?('#map-box').should be_true
  
  within('#main-box') do
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
        find_link I18n.t('places.common_actions.follow')
      end
    end
    
  end
end

def place_view_spec(place)
  page.has_css?('.image').should be_true
  page.should have_content place.name
  page.should have_content place.address
  page.should have_content place.mobility_kindness_index
  page.should have_content Place.human_attribute_name(:mobility_kindness_index)
end

def places_with_ordering_spec(places)
  places.each_with_index do |place, index|
    within("#place-#{place.id}") do
      page.has_css?("order-#{index}")
      place_view_spec(place)
      find_link I18n.t('places.common_actions.follow')
    end
  end
end