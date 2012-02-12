# encoding: utf-8

Factory.define :meta_survey do |ms|
  ms.name "Encuesta Variada"
  ms.category { Factory.build(:restaurant) }
end