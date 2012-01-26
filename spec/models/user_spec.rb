#encoding: utf-8
require 'spec_helper'

describe User do
  
  before(:each) do
    @user = Factory(:user)
  end
  
  it "should accept hashes which include a valid current password" do
    @user.check_parameters_and_password({"password" => "bicibici", "password_confirmation" => "bicibici", "current_password" => @user.password}).should be_true
  end
  
  it "should accept a hash as valid given no password is present" do
    @user.check_parameters_and_password({}).should be_true
  end
  
  it "should reject a hash with invalid password" do
    @user.check_parameters_and_password({"password" => "bicibici", "password_confirmation" => "bicibici", "current_password" => "bicibici"}).should be_false
  end
  
  describe "adding a comment to any place" do
    
    before(:each) do
      
      @place = Factory(:accessible_place)
      @comment = @place.add_comment(@user, "Muy buena comida sirve Doña Pina")
      
    end
    
    it "should be confirmed as commented by the user who wrote it" do
      @user.owns_comment?(@comment).should be_true
    end
    
  end
  
end