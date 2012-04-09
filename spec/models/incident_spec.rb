require 'spec_helper'

describe Incident do
  
  before(:each) do
    @reporter = FactoryGirl.create(:pipo)
  end
  
  it "should not let me save an accident with a malformed vehicle identifier" do
    incident = FactoryGirl.build(:accident, :vehicle_identifier => ".O3P-!DED")
    incident.save.should be_false
  end
  
  it "should not let me save an infraction report with a malformed vehicle identifier" do
    incident = FactoryGirl.build(:regulation_infraction, :vehicle_identifier => "-O3P-DED-")
    incident.save.should be_false
  end
  
  it "should let me save a theft report" do
    incident = FactoryGirl.build(:theft, :vehicle_identifier => "O3P-DED", :user => @reporter)
    incident.save.should be_true
  end
  
  describe "having some incidents registered" do
    
    before(:each) do
      @theft = FactoryGirl.create(:theft, :user => @reporter, :complaint_issued => false)
      @accident = FactoryGirl.create(:accident, :user => @reporter)
      @assault = FactoryGirl.create(:assault, :user => @reporter, :date_and_time => Date.today-2.weeks)
      @regulation_infraction = FactoryGirl.create(:regulation_infraction, :date_and_time => Date.today-1.month)
      @old_incident = FactoryGirl.create(:assault, :user => @reporter, :date_and_time => Date.today-3.years)
    end
    
    describe "fetching by date range" do
    
      it "should retrieve all those incidents that happened during the last week" do
        hash = {
          Incident.kind_for(:accident) => [@accident], 
          Incident.kind_for(:theft) => [@theft],
          :total => 2
        }
        Incident.filtering_with(:range_date => Incident.date_filtering_option_for(:last_week)).should == hash
      end
    
      it "should retrieve all those incidents that happened during the last month" do
        hash = {
          Incident.kind_for(:accident) => [@accident], 
          Incident.kind_for(:theft) => [@theft],
          Incident.kind_for(:assault) => [@assault],
          :total => 3
        }
        Incident.filtering_with(:range_date => Incident.date_filtering_option_for(:last_month)).should == hash
      end
    
      it "should retrieve only all those incidents that happened during the last year" do
        hash = {
          Incident.kind_for(:accident) => [@accident], 
          Incident.kind_for(:theft) => [@theft],
          Incident.kind_for(:assault) => [@assault],
          Incident.kind_for(:regulation_infraction)=> [@regulation_infraction],
          :total => 4
        }
        Incident.filtering_with(:range_date => Incident.date_filtering_option_for(:last_year)).should == hash
      end
    
      it "should retrieve all the incidents when asked to get all" do
        hash = { 
          Incident.kind_for(:assault) => [@assault, @old_incident], 
          Incident.kind_for(:accident) => [@accident], 
          Incident.kind_for(:theft) => [@theft],
          Incident.kind_for(:regulation_infraction)=> [@regulation_infraction],
          :total => 5  
        }
        Incident.filtering_with(:range_date => Incident.date_filtering_option_for(:all)).should == hash
      end
      
    end
    
    describe "fetching by kinds" do
      
      it "should retrieve two incidents when asked to bring only those with kind assault" do
        hash = { 
          Incident.kind_for(:assault) => [@assault, @old_incident],
          :total => 2  
        }
        Incident.filtering_with(:type => {:assault => "1"}).should == hash
      end
      
      it "should retrieve three incidents when asked to bring only those with kind assault and accident" do
        hash = { 
          Incident.kind_for(:assault) => [@assault, @old_incident],
          Incident.kind_for(:accident) => [@accident],
          :total => 3  
        }
        Incident.filtering_with(:type => {:assault => "1", :accident => "1"}).should == hash
      end
      
    end
    
    describe "fetching by issued complaint" do
      
      it "should retrieve one incident when asking to bring those with issued complaint set to false" do
        hash = { 
          Incident.kind_for(:theft) => [@theft],
          :total => 1  
        }
        Incident.filtering_with(:complaint_issued => "false").should == hash
      end
      
      it "should retrieve four results when asking to bring those with issued complaint set to true" do
        hash = { 
          Incident.kind_for(:assault) => [@assault, @old_incident], 
          Incident.kind_for(:accident) => [@accident], 
          Incident.kind_for(:regulation_infraction)=> [@regulation_infraction],
          :total => 4  
        }
        Incident.filtering_with(:complaint_issued => "true").should == hash
      end
      
    end
    
    it "should retrieve all the results when no conditions are set" do
      hash = { 
        Incident.kind_for(:assault) => [@assault, @old_incident], 
        Incident.kind_for(:accident) => [@accident], 
        Incident.kind_for(:theft) => [@theft],
        Incident.kind_for(:regulation_infraction)=> [@regulation_infraction],
        :total => 5  
      }
      Incident.filtering_with.should == hash
      Incident.filtering_with(:nothing).should == hash
    end
  end
  
end