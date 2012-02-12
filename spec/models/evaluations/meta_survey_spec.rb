require 'spec_helper'

describe MetaSurvey do
  
  before(:each) do
    @category = Factory(:restaurant)
  end
  
  it "should register a new MetaSurvey" do
    file = File.open File.join(Rails.root, "spec", "resources", "evaluations", "survey.yml")
    ms = MetaSurvey.register_with(:category_id => @category.id, :survey_descriptor_file => file)
    ms.should be_new_record
    ms.name.should == "Encuesta Diversa"
    ms.category.should == @category
    ms.meta_questions.size.should == 11
  end
end

