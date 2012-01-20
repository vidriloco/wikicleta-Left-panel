# encoding: utf-8

Factory.define :workshop, :class => Category do |c|
  c.standard_name 'workshop'
end

Factory.define :restaurant, :class => Category do |c|
  c.standard_name 'restaurant'
end

Factory.define :museum, :class => Category do |c|
  c.standard_name 'museum'
end

Factory.define :cinema, :class => Category do |c|
  c.standard_name 'cinema'
end

Factory.define :store, :class => Category do |c|
  c.standard_name 'store'
end

Factory.define :transport_station, :class => Category do |c|
  c.standard_name 'transport_station'
end