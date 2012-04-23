module HelperMethods 
  
  def login_with(user, path=new_user_session_path)
    visit path
    login_attr=user.is_a?(Admin) ? "email" : "login"
    fill_in "#{user.class.to_s.downcase}_#{login_attr}", :with => user.email
    fill_in "#{user.class.to_s.downcase}_password", :with => user.password

    find('#login').click
  end
  
  def simulate_click_on_map(coordinates)
    page.execute_script("section.map.simulatePinPoint(#{coordinates[:lat]},#{coordinates[:lon]});")
  end
  
  def place_view_spec(place)
    #page.has_css?('.image').should be_true
    page.should have_content place.name
    #page.should have_content place.address
    #page.should have_content place.mobility_kindness_index
    #page.should have_content Place.human_attribute_name(:mobility_kindness_index)
  end
  
  def hash_link_for(path, section=nil, resource=nil)
    path="http://127.0.0.1:9887#{path}"
    return path+"#" if section.nil? && resource.nil?
    return path+"##{section}/#{resource}" unless resource.nil?
    path+"##{section}"
  end
  
  def accept_confirmation_for
    page.evaluate_script('window.confirm = function() { return true; }')
    yield if block_given?
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
    Authorization.create(:uid => 12345, :provider => provider.to_s, :user_id => Factory(:pipo).id)
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance