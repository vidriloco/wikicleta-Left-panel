#encoding: utf-8
require 'spec_helper'

describe Authorization do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  
  describe "having an authorization strategy registered" do
    
    before(:each) do
      @auth = FactoryGirl.create(:authorization, :user => @user)
    end
    
    it "shouldn't save the same strategy-account twice" do
      second_auth = FactoryGirl.build(:authorization)
      second_auth.save.should be_false
    end
    
    it "shouldn't save a new strategy for a user with a the same strategy already registered" do
      second_auth = FactoryGirl.build(:authorization, :user => @user, :uid => "3242192")
      second_auth.save.should be_false
    end
    
  end
  
end