require "spec_helper"

describe Admins::EvaluationsController do
  
  describe "routing" do
    
    it "should match /admins/evaluations" do
      { :get => '/admins/evaluations' }.should route_to(:controller => 'admins/evaluations', :action => 'index')
    end
    
    it "should match /admins/evaluations/new" do
      { :get => '/admins/evaluations/new' }.should route_to(:controller => 'admins/evaluations', :action => 'new')
    end

    it "should match /admins/evaluations" do
      { :post => '/admins/evaluations' }.should route_to(:controller => 'admins/evaluations', :action => 'create')
    end
  end
  
end