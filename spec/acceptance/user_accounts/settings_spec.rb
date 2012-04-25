#encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'User accounts settings' do

  describe "Given I am not logged in" do
    
    scenario "I should not be able to visit my account, profile nor my access settings" do
      visit settings_access_path
      current_path.should == new_user_session_path
      
      visit settings_account_path
      current_path.should == new_user_session_path
      
      visit settings_profile_path
      current_path.should == new_user_session_path
    end
    
  end

  describe "Given I am logged in" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      login_with(@user)
    end

    scenario 'adjusting my account settings should be possible' do
      visit settings_account_path
            
      find_link I18n.t("user_accounts.settings.account")
      find_link I18n.t("user_accounts.settings.access")
      find_link I18n.t("user_accounts.settings.profile")
      
      fill_in User.human_attribute_name(:full_name), :with => "Pepe Brincolin"
      fill_in User.human_attribute_name(:email), :with => "brinc@lin.com"
      fill_in User.human_attribute_name(:username), :with => "brincolin"
            
      click_on I18n.t("user_accounts.settings.save")
      
      current_path.should == settings_account_path
      
      page.should have_content I18n.t("user_accounts.settings.successful_save")
      
      find_field(User.human_attribute_name(:full_name)).value.should == "Pepe Brincolin"
      find_field(User.human_attribute_name(:email)).value.should == "brinc@lin.com"
      find_field(User.human_attribute_name(:username)).value.should == "brincolin"
    end
    
    scenario "should let me deactivate my account", :js => true do
      visit settings_account_path
      
      accept_confirmation_for do
        click_link I18n.t("user_accounts.settings.sections.account.deactivate")
      end
      
      login_with(@user)
      current_path.should == user_session_path
    end
    
    scenario "adjusting my access settings should be possible" do
      visit settings_access_path
            
      find_link I18n.t("user_accounts.settings.account")
      find_link I18n.t("user_accounts.settings.access")
      find_link I18n.t("user_accounts.settings.profile")
      
      fill_in User.human_attribute_name(:password), :with => "bicicleta"
      fill_in User.human_attribute_name(:password_confirmation), :with => "bicicleta"
      fill_in "current_password", :with => "passwd"
      
      click_on I18n.t("user_accounts.settings.save")
      current_path.should == settings_access_path
      
      page.should have_content I18n.t("user_accounts.settings.successful_save")
      
      User.find(@user.id).valid_password?("bicicleta").should be_true
    end
    
    describe "and being myself an externally logged-in user" do
    
      before(:each) do
        FactoryGirl.create(:authorization, :user_id => @user.id)
      end
    
      scenario "if I forgot my password I should be able to request a new password to be send to my email" do
        
        visit settings_profile_path
        click_on I18n.t("user_accounts.settings.access")
        
        page.should have_content I18n.t('user_accounts.settings.sections.access.recover_password')
        
        #click_on I18n.t('user_accounts.settings.sections.access.reset')
        
        #page.should have_content I18n.t('devise.passwords.send_instructions')
      end
    end
    
    scenario "it should let me change my bio and personal page through my profile settings section" do
      visit settings_profile_path
            
      find_link I18n.t("user_accounts.settings.account")
      find_link I18n.t("user_accounts.settings.access")
      find_link I18n.t("user_accounts.settings.profile")
      
      page.should have_content @user.full_name
      click_link I18n.t("user_accounts.settings.sections.profile.change_name")
      current_path.should == settings_account_path
      
      visit settings_profile_path
      
      fill_in User.human_attribute_name(:bio), :with => "Soy una persona multimodal. Bici + Transporte público"
      fill_in User.human_attribute_name(:personal_page), :with => "chorochido.blogspot.com"
      
      click_on I18n.t("user_accounts.settings.save")
      
      find_field(User.human_attribute_name(:bio)).value.should == "Soy una persona multimodal. Bici + Transporte público"
      find_field(User.human_attribute_name(:personal_page)).value.should == "chorochido.blogspot.com"
    end
    
    scenario "it should let me add and remove social network accounts"
    scenario "it should let me change my avatar through my profile settings section"
    scenario "it should let me change my account background through my profile settings section"
      
      
  end

end
