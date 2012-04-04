# encoding: utf-8

FactoryGirl.define do
  factory :admin do |a|
    a.password "passwd"
    a.password_confirmation "passwd"
    a.email "root@wikiando.com"
  end
end