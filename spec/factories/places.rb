# encoding: utf-8
=begin
FactoryGirl.define do
  
  factory :accessible_place, :class => Place do |p|
    p.name "Lugar de fácil acceso"
    p.mobility_kindness_index 10
    p.description "Una decripción para un lugar al que se puede llegar fácilmente"
    p.address "A given address"
    p.twitter "accessibletwitter"
    # a una cuadra del metro chilpancingo
    p.coordinates Point.from_lon_lat(-99.171610, 19.405704, 4326)
    p.category FactoryGirl.build(:restaurant)
    
  end
  
  factory :popular_place, :class => Place do |p|
    p.name "Lugar Popular"
    p.mobility_kindness_index 6
    p.description "Una decripción para un lugar que se ha vuelto popular"
    p.address "A given address"
    p.twitter "populartwitter"
    # a una cuadra del metro nativitas
    p.coordinates Point.from_lon_lat(-99.140496, 19.378269, 4326)
    p.category FactoryGirl.build(:transport_station)
    
  end
  
  factory :recent_place, :class => Place do |p|
    p.name "Lugar Reciente"
    p.mobility_kindness_index 1
    p.description "Una decripción para un lugar recientemente agregado"
    p.address "A given address"
    p.twitter "recenttwitter"
    # la virgen y eje 3 ote
    p.coordinates Point.from_lon_lat(-99.113674, 19.320731, 4326)
    p.category FactoryGirl.build(:workshop)
    
  end
  
end 
=end