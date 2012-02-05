module HelperMethods 
  
  def login_with(user, path)
    visit new_user_session_path
    fill_in User.human_attribute_name(:email), :with => user.username
    fill_in User.human_attribute_name(:password), :with => user.password
    click_on I18n.t("user_accounts.sessions.new.start")
  end
  
  def simulate_click_on_map(coordinates)
    page.execute_script("mapWrap.simulatePinPoint(#{coordinates[:lat]},#{coordinates[:lon]});")
  end
  
  def place_view_spec(place)
    page.has_css?('.image').should be_true
    page.should have_content place.name
    page.should have_content place.address
    page.should have_content place.mobility_kindness_index
    page.should have_content Place.human_attribute_name(:mobility_kindness_index)
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance