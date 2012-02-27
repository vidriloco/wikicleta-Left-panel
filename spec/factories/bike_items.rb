# encoding: utf-8

FactoryGirl.define do
  factory :bike_item do |u|
    u.name "Cadena simple"
    u.details "Tipo Knog"
    u.category BikeItem.categories[:security]
  end
  
end
