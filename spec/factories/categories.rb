# encoding: utf-8
=begin 
FactoryGirl.define do
  factory :workshop, :class => Category do |c|
    c.standard_name 'workshop'
  end
  
  factory :restaurant, :class => Category do |c|
    c.standard_name 'restaurant'
  end
  
  factory :museum, :class => Category do |c|
    c.standard_name 'museum'
  end
  
  factory :cinema, :class => Category do |c|
    c.standard_name 'cinema'
  end
  
  factory :store, :class => Category do |c|
    c.standard_name 'store'
  end
  
  factory :transport_station, :class => Category do |c|
     c.standard_name 'transport_station'
   end
end
=end
