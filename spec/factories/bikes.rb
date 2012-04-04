# encoding: utf-8

FactoryGirl.define do
  factory :bike do |u|
    u.name "Hashi"
    u.description "Una buena bici"
    u.association(:user) { FactoryGirl.create(:pancho) }
    u.kind Bike.category_for(:types, :urban)
    u.bike_brand FactoryGirl.create(:dahon)
  end
  
  factory :alternate_bike, :class => "Bike" do |u|
    u.name "La condenada"
    u.description "La bici de la Jim"
    u.association(:user) { FactoryGirl.create(:user) }
    u.kind Bike.category_for(:types, :mountain)
    u.bike_brand FactoryGirl.create(:specialized)
  end
  
end
