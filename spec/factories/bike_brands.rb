# encoding: utf-8

FactoryGirl.define do
  factory :specialized, :class => "BikeBrand" do |u|
    u.name "Specialized"
  end  
  
  factory :dahon, :class => "BikeBrand" do |u|
    u.name "Dahon"
  end
end
