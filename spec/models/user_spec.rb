#encoding: utf-8
require 'spec_helper'

describe User do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  
  it "should accept hashes which include a valid current password" do
    @user.check_parameters_and_password({"password" => "bicibici", "password_confirmation" => "bicibici", "current_password" => @user.password}).should be_true
  end
  
  it "should accept a hash as valid given no password is present" do
    @user.check_parameters_and_password({}).should be_true
  end
  
  it "should reject a hash with invalid password" do
    @user.check_parameters_and_password({"password" => "bicibici", "password_confirmation" => "bicibici", "current_password" => "carcarcar"}).should be_false
  end
  
  it "should reject a username with spaces" do
    user = FactoryGirl.build(:pipo, :username => "spaced username")
    user.save.should be_false
  end
  
end