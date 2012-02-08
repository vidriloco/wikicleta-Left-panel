# encoding: utf-8

Factory.define :admin do |a|
  a.password "passwd"
  a.password_confirmation "passwd"
  a.email "root@wikiando.com"
end