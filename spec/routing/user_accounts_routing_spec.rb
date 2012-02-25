require "spec_helper"

describe "User accounts routing" do
  describe "routes" do
    it "matches /sign_up with controller action #new on registrations" do
      { :get => "/sign_up" }.should route_to(:action=>"new", :controller=>"devise/registrations")
    end
    
    it "matches /sign_in with controller action #new on sessions" do
      { :get => "/sign_in" }.should route_to(:action=>"new", :controller=>"devise/sessions")
    end
    
    it "matches /sign_out with controller action #destroy on sessions" do
      { :delete => "/sign_out" }.should route_to(:action=>"destroy", :controller=>"devise/sessions")
    end
    
    it "matches /log_in with controller action #create on sessions" do
      { :post => "/log_in" }.should route_to(:action=>"create", :controller=>"devise/sessions")
    end
    
    it "matches /account/create with controller action #create on registrations" do
      { :post => "/account/create" }.should route_to(:action=>"create", :controller=>"devise/registrations")
    end
    
    it "matches /users/auth/create with controller action #create on omniauth_callbacks" do
      { :post => "/users/auth/create" }.should route_to(:action=>"create", :controller=>"users/omniauth_callbacks")
    end
    
    it "matches /users/auth/cancel with controller action #cancel on omniauth_callbacks" do
      { :delete => "/users/auth/cancel" }.should route_to(:action => "cancel", :controller => "users/omniauth_callbacks")
    end
    
    it "matches /account/deactivate with controller action #delete on registrations" do
      { :delete => "/account/deactivate" }.should route_to(:action=>"destroy", :controller=>"devise/registrations")
    end
    
    it "matches /account/recover_password with controller action #new on passwords" do
      { :get => "/account/recover_password" }.should route_to(:action=>"new", :controller=>"devise/passwords")
    end
    
    it "matches /account/reset_password with controller action #edit on passwords" do
      { :get => "/account/reset_password" }.should route_to(:action=>"edit", :controller=>"devise/passwords")
    end
  end
end