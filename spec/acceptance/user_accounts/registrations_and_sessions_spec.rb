require 'acceptance/acceptance_helper'

feature 'User accounts registration' do

  describe "Given I am on the new registration page" do

    before(:each) do
      visit sign_up_path
    end

    scenario 'it should let me register given I provide the required data in the registration form' do
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
    
    scenario "should not let me register if I do not provide the required data in the registration form" do
      click_on I18n.t("user_accounts.registrations.new.commit")
      
      current_path.should_not be(root_path)
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
