#encoding: utf-8
require 'spec_helper'

describe StreetMark do
  
  before(:each) do
    user = Factory(:user)
    @params = {
      :segment_path => [{"Ua"=>19.440121960646767, "Va"=>-99.1538430266113}, {"Ua"=>19.43154236256068, "Va"=>-99.19006357714841}],
      :name => "Some street segment"
    }
    @params_with_user = @params.clone.merge(:user => user)
  end
  
  it "should generate a new street mark" do
    street_mark = StreetMark.build_new(@params_with_user)
    street_mark.name.should == "Some street segment"
    
    coords_list=[
      Point.from_lon_lat(@params[:segment_path][0]["Va"], @params[:segment_path][0]["Ua"], 4326),
      Point.from_lon_lat(@params[:segment_path][1]["Va"], @params[:segment_path][1]["Ua"], 4326)
    ]
    
    street_mark.segment_path.should == LineString.from_points(coords_list, 4326)
  end
  
  describe "having a street mark saved" do
    
    before(:each) do
      @street_mark =  StreetMark.build_new(@params_with_user)
      @street_mark.save
    end
    
    it "should generate a custom JSON representation" do
      attrs={:id => @street_mark.id, :created_at => @street_mark.created_at.to_time.iso8601, :updated_at => @street_mark.updated_at.to_time.iso8601}
      @street_mark.to_json.should == @params.merge(attrs).to_json
    end
    
  end
  
end