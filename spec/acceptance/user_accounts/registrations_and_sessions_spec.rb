require 'acceptance/acceptance_helper'

feature 'User accounts registration' do

  describe "Given I am on the new registration page then" do

    before(:each) do
      visit sign_up_path
    end

    scenario 'I can register given I provide the required data in the registration form' do
      current_path.should == "/sign_up"
      
      page.should have_content I18n.t("user_accounts.registrations.new.title")
            
      fill_in "user_full_name", :with => "Pepe Cocolin"
      fill_in "user_email", :with => "pepe@example.com"
      fill_in "user_password", :with => "mysecret"
      fill_in "user_password_confirmation", :with => "mysecret"
      
      fill_in "user_username", :with => "pepito bad"
      click_on I18n.t("user_accounts.registrations.new.commit")
      
      page.should have_content I18n.t('user_accounts.validations.invalid_username')
      
      fill_in "user_username", :with => "pepito"
      fill_in "user_password", :with => "mysecret"
      fill_in "user_password_confirmation", :with => "mysecret"
      
      click_on I18n.t("user_accounts.registrations.new.commit")
      
      current_path.should == root_path
    end
    
    scenario "I cannot register if I do not provide the required data in the registration form" do
      click_on I18n.t("user_accounts.registrations.new.commit")
      
      current_path.should_not be(root_path)
    end
    
    describe "using Omniauth authentication" do
    
      before(:each) do
        OmniAuth.config.test_mode = true
      end
      
      describe "with an unsuccessful login" do
        
        before(:each) do
          OmniAuth.config.mock_auth[:twitter] = :invalid_message
        end
        
        scenario "renders a failure login page" do
        
          visit new_user_session_path
          click_on "twitter_sign_in"
      
          page.current_path.should == user_omniauth_callback_path(:twitter)
          page.should have_content I18n.t("devise.omniauth_callbacks.failure")
        
          find_link I18n.t('actions.back')
        end
        
      end
      
      describe "using my twitter account" do
      
        before(:each) do
          mock_omniauth_for(:twitter)
        end
            
        scenario "I can register and log-in", :js => true do
          visit new_user_session_path
          click_on "twitter_sign_in"
        
          page.current_path.should == user_omniauth_callback_path(:twitter)
        
          page.should have_content I18n.t("user_accounts.registrations.oauth.twitter.new.title")
          click_on I18n.t('user_accounts.registrations.oauth.commit')
        
          page.current_path.should == users_auth_sign_up_path
        
          fill_in "user_email", :with => "mymail@example.com"
          click_on I18n.t('user_accounts.registrations.oauth.commit')
          
          page.current_path.should == root_path
          page.should have_content I18n.t("devise.omniauth_callbacks.success", :kind => "Twitter")
        end
      
        scenario "I can cancel the registration process" do
          visit new_user_session_path
          click_on "twitter_sign_in"
        
          page.current_path.should == user_omniauth_callback_path(:twitter)
          click_on I18n.t('actions.registrations.cancel')
          page.current_path.should == new_user_session_path
        end
      
        describe "having previously logged-in with my twitter account" do
        
          before(:each) do
            FactoryGirl.create(:authorization, :uid => "12345", :provider => "twitter", :secret => "secr", :user_id => FactoryGirl.create(:user, :externally_registered => true))
            mock_omniauth_user_for(:twitter)
          end
        
          scenario "I can log-in again with it", :js => true do
            visit new_user_session_path
            click_on "twitter_sign_in"

            page.current_path.should == root_path
            page.should have_content I18n.t("devise.omniauth_callbacks.success", :kind => "Twitter")
          end
        
          scenario "In the settings section I should not see the option for changing my password" do
            visit new_user_session_path
            click_on "twitter_sign_in"
            
            click_on I18n.t('menu.profile')
            click_on I18n.t('user_profiles.menu.settings')
            click_on I18n.t('user_accounts.settings.access')
            
            page.should have_content I18n.t('user_accounts.settings.sections.access.change_password_for_external_registration')
            page.should have_content I18n.t('user_accounts.settings.sections.access.set_password_for_external_registration')
            #find_button I18n.t('user_accounts.passwords.set_password')
          end
        end
      end
      
      describe "using my facebook account" do
        before(:each) do
          mock_omniauth_for(:facebook)
        end
        
        scenario "I can register and log-in", :js => true do
          visit new_user_session_path
          click_on "facebook_sign_in"
        
          page.current_path.should == user_omniauth_callback_path(:facebook)
        
          page.should have_content I18n.t("user_accounts.registrations.oauth.facebook.new.title")
          click_on I18n.t('user_accounts.registrations.oauth.commit')
          
          page.current_path.should == users_auth_sign_up_path
        
          fill_in "user_username", :with => "vidriloco ee"
          click_on I18n.t('user_accounts.registrations.oauth.commit')
          page.should have_content I18n.t('user_accounts.validations.invalid_username')
        
          fill_in "user_username", :with => "vidriloco"
          click_on I18n.t('user_accounts.registrations.oauth.commit')
          
          page.current_path.should == root_path
          page.should have_content I18n.t("devise.omniauth_callbacks.success", :kind => "Facebook")
        end
      
        scenario "I can cancel the registration process" do
          visit new_user_session_path
          click_on "facebook_sign_in"
        
          page.current_path.should == user_omniauth_callback_path(:facebook)
          click_on I18n.t('actions.registrations.cancel')
          sleep 4
          page.current_path.should == new_user_session_path
        end
        
        describe "having previously logged-in with my facebook account" do
        
          before(:each) do
            FactoryGirl.create(:authorization, :uid => "12345", :provider => "facebook", :secret => "secr", :user_id => FactoryGirl.create(:user, :externally_registered => true))
            mock_omniauth_user_for(:facebook)
          end
        
          scenario "I can log-in again with it", :js => true do
            visit new_user_session_path
            click_on "facebook_sign_in"

            page.current_path.should == root_path
            page.should have_content I18n.t("devise.omniauth_callbacks.success", :kind => "Facebook")
          end
          
          scenario "In the settings section I should not see the option for changing my password" do
            visit new_user_session_path
            click_on "facebook_sign_in"
            
            click_on I18n.t('menu.profile')
            click_on I18n.t('user_profiles.menu.settings')
            click_on I18n.t('user_accounts.settings.access')
            
            page.should have_content I18n.t('user_accounts.settings.sections.access.change_password_for_external_registration')
            page.should have_content I18n.t('user_accounts.settings.sections.access.set_password_for_external_registration')
            #find_button I18n.t('user_accounts.passwords.set_password')
          end
        
        end
      end
    end
  end
  
  describe "Given a user exists with the username: pepito" do
    
    before(:each) do
      @user=FactoryGirl.create(:user)
    end
    
    scenario "I should not be able to get registered with that same username" do
      visit sign_up_path

      fill_in "user_full_name", :with => "Pepe Cocolin"
      fill_in "user_email", :with => "pepe@example.com"
      fill_in "user_password", :with => "mysecret"
      fill_in "user_password_confirmation", :with => "mysecret"
      
      fill_in "user_username", :with => "pepito"

      click_on I18n.t("user_accounts.registrations.new.commit")
      
      current_path.should_not be(root_path)
    end
    
  end
  
  describe "Given I am on the log-in page" do
    
    before(:each) do
      visit new_user_session_path
    end
    
    scenario "and I cannot remember my password, it should help me to set a new one" do
      
      click_link I18n.t("user_accounts.forgot_password")
      current_path.should == account_recover_password_path
      page.should have_content I18n.t("user_accounts.forgot_password")
      
      fill_in "user_email", :with => "pepe@example.com"
      click_on I18n.t("user_accounts.passwords.reset_password")
    end
    
    scenario "and I can go to the registration form given I am not registered" do
      click_link I18n.t("user_accounts.sessions.new.sign_up")
      current_path.should == "/sign_up"
    end    

=begin    
    describe "and I have registered before", :js => true do

      before(:each) do
        @user=FactoryGirl.create(:user)
        visit new_user_session_path
      end

      scenario "should let me sign in using my username" do
        current_path.should == "/sign_in"
        
        page.should have_content I18n.t("user_accounts.sessions.new.title")
        fill_in "user_login", :with => @user.username
        fill_in "user_password", :with => "passwd"
        
        click_on I18n.t("user_accounts.sessions.new.start")
        
        current_path.should == root_path
      end

      scenario "should let me sign in using my email" do
        current_path.should == "/sign_in"
        
        page.should have_content I18n.t("user_accounts.sessions.new.title")
        fill_in "user_login", :with => @user.email
        fill_in "user_password", :with => "passwd"
        
        click_on I18n.t("user_accounts.sessions.new.start")
        
        current_path.should == root_path
      end

    end
=end

  end

end
