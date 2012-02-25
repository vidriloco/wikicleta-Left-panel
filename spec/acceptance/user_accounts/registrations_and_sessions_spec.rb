require 'acceptance/acceptance_helper'

feature 'User accounts registration' do

  describe "Given I am on the new registration page then" do

    before(:each) do
      visit sign_up_path
    end

    scenario 'I can register given I provide the required data in the registration form' do
      current_path.should == "/sign_up"
      
      page.should have_content I18n.t("user_accounts.registrations.new.title")
            
      fill_in User.human_attribute_name(:full_name), :with => "Pepe Cocolin"
      fill_in User.human_attribute_name(:email), :with => "pepe@example.com"
      fill_in User.human_attribute_name(:password), :with => "mysecret"
      fill_in User.human_attribute_name(:password_confirmation), :with => "mysecret"
      
      fill_in User.human_attribute_name(:username), :with => "pepito"
      
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
      
      describe "using my twitter account" do
      
        before(:each) do
          mock_omniauth_for(:twitter)
        end
      
        scenario "I can register and log-in" do
          visit new_user_session_path
          click_on I18n.t('user_accounts.omniauth.login', :network => "Twitter")
        
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
          click_on I18n.t('user_accounts.omniauth.login', :network => "Twitter")
        
          page.current_path.should == user_omniauth_callback_path(:twitter)
          click_on I18n.t('actions.registrations.cancel')
          page.current_path.should == new_user_session_path
        end
      
        describe "having previously logged-in with my twitter account" do
        
          before(:each) do
            Factory(:authorization, :uid => "12345", :provider => "twitter", :secret => "secr", :user_id => Factory(:user))
            mock_omniauth_user_for(:twitter)
          end
        
          scenario "I can log-in again with it" do
            visit new_user_session_path
            click_on I18n.t('user_accounts.omniauth.login', :network => "Twitter")

            page.current_path.should == root_path
            page.should have_content I18n.t("devise.omniauth_callbacks.success", :kind => "Twitter")
          end
        
        end
      end
      
      describe "using my facebook account" do
        before(:each) do
          mock_omniauth_for(:facebook)
        end
        
        scenario "I can register and log-in" do
          visit new_user_session_path
          click_on I18n.t('user_accounts.omniauth.login', :network => "Facebook")
        
          page.current_path.should == user_omniauth_callback_path(:facebook)
        
          page.should have_content I18n.t("user_accounts.registrations.oauth.facebook.new.title")
          click_on I18n.t('user_accounts.registrations.oauth.commit')
          
          page.current_path.should == users_auth_sign_up_path
        
          fill_in "user_username", :with => "vidriloco"
          click_on I18n.t('user_accounts.registrations.oauth.commit')
        
          page.current_path.should == root_path
          page.should have_content I18n.t("devise.omniauth_callbacks.success", :kind => "Facebook")
        end
      
        scenario "I can cancel the registration process" do
          visit new_user_session_path
          click_on I18n.t('user_accounts.omniauth.login', :network => "Facebook")
        
          page.current_path.should == user_omniauth_callback_path(:facebook)
          click_on I18n.t('actions.registrations.cancel')
          page.current_path.should == new_user_session_path
        end
        
        describe "having previously logged-in with my facebook account" do
        
          before(:each) do
            Factory(:authorization, :uid => "12345", :provider => "facebook", :secret => "secr", :user_id => Factory(:user))
            mock_omniauth_user_for(:facebook)
          end
        
          scenario "I can log-in again with it" do
            visit new_user_session_path
            click_on I18n.t('user_accounts.omniauth.login', :network => "Facebook")

            page.current_path.should == root_path
            page.should have_content I18n.t("devise.omniauth_callbacks.success", :kind => "Facebook")
          end
        
        end
      end
    end
  end
  
  describe "Given a user exists with the username: pepito" do
    
    before(:each) do
      @user=Factory(:user)
    end
    
    scenario "It should let me logout given I am logged in" do
      login_with(@user)
      visit settings_account_path
      click_on "Sign out"
      visit settings_account_path
      current_path.should == new_user_session_path
    end
    
    scenario "I should not be able to get registered with that same username" do
      visit sign_up_path

      fill_in User.human_attribute_name(:full_name), :with => "Pepe Cocolin"
      fill_in User.human_attribute_name(:email), :with => "pepe@example.com"
      fill_in User.human_attribute_name(:password), :with => "mysecret"
      fill_in User.human_attribute_name(:password_confirmation), :with => "mysecret"
      
      fill_in User.human_attribute_name(:username), :with => "pepito"
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
      
      fill_in User.human_attribute_name(:email), :with => "pepe@example.com"
      click_on I18n.t("user_accounts.passwords.reset_password")
    end
    
    scenario "and I can go to the registration form given I am not registered" do
      click_link I18n.t("user_accounts.sessions.new.sign_up")
      current_path.should == "/sign_up"
    end    
    
    describe "and I have registered before" do

      before(:each) do
        Factory(:user)
      end

      scenario "should let me sign in using my username" do
        current_path.should == "/sign_in"

        page.should have_content I18n.t("user_accounts.sessions.new.title")
        fill_in User.human_attribute_name(:login), :with => "pepito"
        fill_in User.human_attribute_name(:password), :with => "passwd"

        click_on I18n.t("user_accounts.sessions.new.start")

        current_path.should == root_path
      end

      scenario "should let me sign in using my email" do
        visit new_user_session_path
        current_path.should == "/sign_in"

        page.should have_content I18n.t("user_accounts.sessions.new.title")
        fill_in User.human_attribute_name(:login), :with => "pepe@example.com"
        fill_in User.human_attribute_name(:password), :with => "passwd"

        click_on I18n.t("user_accounts.sessions.new.start")

        current_path.should == root_path
      end

    end
    
  end

end
