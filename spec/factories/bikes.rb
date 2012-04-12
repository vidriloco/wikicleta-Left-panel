# encoding: utf-8

FactoryGirl.define do
  factory :bike do |u|
    u.name "Hashi"
    u.description "Una buena bici"
    u.sequence(:user) { |u| FactoryGirl.create(:pancho, :email => "email#{n}@example.com", :username => "user #{n}") }
    u.kind Bike.category_for(:types, :urban)
    u.bike_brand FactoryGirl.create(:dahon)
    u.main_photo File.new(Rails.root + 'spec/resources/bike.jpg')
  end
  
  factory :alternate_bike, :class => "Bike" do |u|
    u.name "La condenada"
    u.description "La bici de la Jim"
    u.sequence(:user) { |u| FactoryGirl.create(:user, :email => "emailme#{n}@example.com", :username => "user.nice #{n}") }
    u.kind Bike.category_for(:types, :mountain)
    u.bike_brand FactoryGirl.create(:specialized)
    u.main_photo File.new(Rails.root + 'spec/resources/bike.jpg')
  end
  
end
