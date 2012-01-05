# encoding: utf-8

Factory.define :user do |u|
  u.password "passwd"
  u.password_confirmation "passwd"
  u.email "pepe@example.com"
  u.full_name "Francisco Opa"
  u.username "pepito"
end