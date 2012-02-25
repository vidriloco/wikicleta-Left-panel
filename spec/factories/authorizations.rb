# encoding: utf-8

FactoryGirl.define do
  factory :authorization do |u|
    u.uid "1"
    u.provider "twitter"
    u.token "tkn"
  end
end