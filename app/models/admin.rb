class Admin < ActiveRecord::Base
  devise :database_authenticatable, :validatable, :authentication_keys => [:email]

  attr_accessible :email, :password, :password_confirmation
end
