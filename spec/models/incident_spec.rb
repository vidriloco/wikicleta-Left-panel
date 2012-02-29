require 'spec_helper'

describe Incident do
  
  it "should not let me save an accident with a malformed vehicle identifier" do
    incident = Factory.build(:accident, :vehicle_identifier => ".O3P-!DED")
    incident.save.should be_false
  end
  
  it "should not let me save an infraction report" do
    incident = Factory.build(:regulation_infraction, :vehicle_identifier => "-O3P-DED-")
    incident.save.should be_false
  end
  
  it "should let me save a theft report" do
    incident = Factory.build(:theft, :vehicle_identifier => "-O3P-DED-")
    incident.save.should be_true
  end
end