# encoding: utf-8
require 'acceptance/acceptance_helper'

feature "Login and access management:" do
  
  describe "If logged-in" do
    
    before(:each) do
      @admin = Factory(:admin)
      login_with(@admin, new_admin_session_path)
    end
    
    scenario "it should send me to the main panel page" do
      current_path.should == admins_index_path      
    end
    
  end
  
  describe "If NOT logged-in" do
    
    scenario "attempting to visit the administration panel should redirect me to the login page" do
      visit admins_index_path
      current_path.should == new_admin_session_path
    end
    
  end
    
end