module HelperMethods

  def login_with(user)
    visit new_user_session_path
    fill_in User.human_attribute_name(:email), :with => user.username
    fill_in User.human_attribute_name(:password), :with => user.password
    click_on I18n.t("user_accounts.sessions.new.start")
  end
  
  def simulate_click_on_map(coordinates)
    page.execute_script("mapWrap.simulatePinPoint(#{coordinates[:lat]},#{coordinates[:lon]});")
  end
  
end

RSpec.configuration.include HelperMethods, :type => :acceptance