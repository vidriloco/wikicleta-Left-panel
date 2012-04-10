#encoding: utf-8
require 'spec_helper'

describe IncidentsHelper do
  
  it "should generate the annotating classes for the given type of incident" do
    incident_types_for(:assault).should == "incident-selectable incident-#{Incident.kind_for(:assault)}"
  end
  
  it "should generate the annotating classes for the given types of incidents" do
    incident_types_for([:assault, :accident]).should == "incident-selectable incident-#{Incident.kind_for(:assault)} incident-#{Incident.kind_for(:accident)}"
  end
  
end