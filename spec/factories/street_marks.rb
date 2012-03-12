# encoding: utf-8

FactoryGirl.define do
  
  # simple example cases for StreetMarks model
  factory :street_mark do |sm|
    sm.association(:user) { Factory.build(:pancho) }
    sm.name "A simple street mark"
    sm.segment_path LineString.from_points([Point.from_lon_lat(-99.2323, 19.3222, 4326), Point.from_lon_lat(-99.3323, 19.1222, 4326)], 4326)
  end
  
end