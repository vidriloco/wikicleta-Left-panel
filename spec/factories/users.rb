# encoding: utf-8

FactoryGirl.define do
  factory :user do |u|
    u.password "passwd"
    u.password_confirmation "passwd"
    u.email "pepe@example.com"
    u.full_name "Francisco Opa"
    u.username "pepito"
  end
  
  factory :pipo, :class => "User" do |u|
    u.password "passwd"
    u.password_confirmation "passwd"
    u.email "pipo@example.com"
    u.full_name "Pipo Olin"
    u.username "pipo"
  end
  
  factory :pancho, :class => "User" do |u|
    u.password "passwd"
    u.password_confirmation "passwd"
    u.email "pancho@example.com"
    u.full_name "Pancho Gomez"
    u.username "pancho"
  end
  
  factory :someone, :class => "User" do |u|
    u.email "someone@example.com"
    u.full_name "Someone P"
    u.username "someone"
  end
end
