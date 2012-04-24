#encoding: utf-8
require 'spec_helper'

describe Authorization do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  
  describe "having an authorization strategy registered" do
    
    before(:each) do
      @auth = FactoryGirl.create(:authorization, :user => @user, :provider => "twitter", :uid => "3242192")
    end
    
    it "shouldn't let me register a new strategy from the same provider" do
      second_auth = FactoryGirl.build(:authorization, :provider => "twitter", :user => @user)
      second_auth.save.should be_false
    end
    
    it "shouldn't let me register a strategy registered associated to an already registered uid" do
      second_auth = FactoryGirl.build(:authorization, :uid => "3242192", :provider => "twitter")
      second_auth.save.should be_false
    end
    
  end
  
end