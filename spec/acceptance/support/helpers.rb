module HelperMethods 
  
  def login_with(user, path=new_user_session_path)
    visit path
    fill_in User.human_attribute_name(:email), :with => user.email
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
  
  def mock_omniauth_for(provider)
    if provider.eql?(:twitter)
      OmniAuth.config.mock_auth[provider] = {
        "provider" => 'twitter',
        "uid" => '12345',
        "info" => {
          "name" => "A user's name",
          "nickname" => "usernicks"
        },
        "credentials" => {
          "token" => "tkn",
          "secret" => "secr"
        }
      }
    elsif provider.eql?(:facebook)
      OmniAuth.config.mock_auth[provider] = {
        "provider" => 'facebook',
        "uid" => '12345',
        "extra" => { 
          "raw_info" => {
            "name" => "A user's name",
            "email" => "user@email.com"
          } 
        },
        "credentials" => {
          "token" => "tkn",
          "secret" => "secr"
        }
      }
    end
  end
  
  def mock_omniauth_user_for(provider)
    hash = {"info" => {"name" => "A user's name", "nickname" => "usernicks"}}
    Authorization.create(:uid => 12345, :provider => provider.to_s, :user => User.create_from_hash!(hash))
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance