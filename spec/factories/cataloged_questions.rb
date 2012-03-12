# encoding: utf-8

FactoryGirl.define do
  
  # simple example cases for StreetMarks model
  factory :fast, :class => "CatalogedAnswer" do |ca|
    ca.content "Rápido"
  end
  
  factory :slow, :class => "CatalogedAnswer" do |ca|
    ca.content "Lento"
  end
  
  factory :low, :class => "CatalogedAnswer" do |ca|
    ca.content "Alta"
  end
  
  factory :high, :class => "CatalogedAnswer" do |ca|
    ca.content "Baja"
  end
  
  factory :cars_speed, :class => "CatalogedQuestion" do |cq|
    cq.model_klass StreetMark.class.to_s
    cq.content "Flujo Vehicular es: "
    cq.order 1
    cq.cataloged_answers { [Factory.build(:fast), Factory.build(:slow)] }
  end
  
  factory :comfortable, :class => "CatalogedQuestion" do |cq|
    cq.model_klass StreetMark.class.to_s
    cq.content "Comodidad"
    cq.order 2
    cq.cataloged_answers { [Factory.build(:low), Factory.build(:high)] }
  end
  
end