#encoding: utf-8
require 'spec_helper'

describe IncidentsHelper do
  
  it "should generate the annotating classes for the given type of incident" do
    incident_types_for(:assault).should == " incident-#{Incident.kind_for(:assault)} incident-selectable"
    incident_types_for([:assault, :accident]).should == " incident-#{Incident.kind_for(:assault)} incident-#{Incident.kind_for(:accident)} incident-selectable"
  end
  
end