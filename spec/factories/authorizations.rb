# encoding: utf-8

FactoryGirl.define do
  factory :authorization do |u|
    u.sequence(:uid) { |n| "#{n}" }
    u.sequence(:provider) { |n| "twitter #{n}" }
    u.sequence(:token) { |n| "token #{n}" }
  end
end