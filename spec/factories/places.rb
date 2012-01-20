# encoding: utf-8

FactoryGirl.define do
  
  factory :accessible_place, :class => Place do |p|
    p.name "Lugar de fácil acceso"
    p.mobility_kindness_index 10
    p.description "A given description"
    p.address "A given address"
    p.twitter "accessibletwitter"
    p.coordinates Point.from_lon_lat(-99.171610, 19.405704, 4326)
    p.category Factory.build(:transport_station)
    
  end
  
  factory :popular_place, :class => Place do |p|
    p.name "Lugar Popular"
    p.mobility_kindness_index 6
    p.description "A given description"
    p.address "A given address"
    p.twitter "populartwitter"
    p.coordinates Point.from_lon_lat(-99.171610, 19.405704, 4326)
    p.category Factory.build(:restaurant)
    
  end
  
  factory :recent_place, :class => Place do |p|
    p.name "Lugar Reciente"
    p.mobility_kindness_index 1
    p.description "A given description"
    p.address "A given address"
    p.twitter "recenttwitter"
    p.coordinates Point.from_lon_lat(-99.171610, 19.405704, 4326)
    p.category Factory.build(:workshop)
    
  end
  
end 
