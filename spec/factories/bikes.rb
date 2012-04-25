# encoding: utf-8

FactoryGirl.define do
  factory :bike do |u|
    u.name "Hashi"
    u.description "Una buena bici"
    u.sequence(:user) { |u| FactoryGirl.create(:pancho, :email => "email#{u}@example.com", :username => "user#{u}s") }
    u.kind Bike.category_for(:types, :urban)
    u.bike_brand FactoryGirl.create(:dahon)
  end
  
  factory :alternate_bike, :class => "Bike" do |u|
    u.name "La condenada"
    u.description "La bici de la Jim"
    u.sequence(:user) { |u| FactoryGirl.create(:user, :email => "emailme#{u}@example.com", :username => "user_nice#{u}") }
    u.kind Bike.category_for(:types, :mountain)
    u.bike_brand FactoryGirl.create(:specialized)
  end
  
end
