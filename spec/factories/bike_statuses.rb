# encoding: utf-8

FactoryGirl.define do
  factory :bike_share, :class => "BikeStatus" do |u|
    u.concept Bike.category_for(:statuses, :share)
  end
  
  factory :bike_sell, :class => "BikeStatus" do |u|
    u.concept Bike.category_for(:statuses, :sell)
  end
  
  factory :bike_rent, :class => "BikeStatus" do |u|
    u.concept Bike.category_for(:statuses, :rent)
  end

end
