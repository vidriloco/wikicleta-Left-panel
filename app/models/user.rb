class User < ActiveRecord::Base
  
  tango_user
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :username, :login, :bio, :personal_page
  validates_presence_of :username, :full_name
  validates_uniqueness_of :username
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end
  
  def check_parameters_and_password(hash)
    return self.valid_password?(hash["current_password"]) if hash.has_key?("current_password")
    true
  end
end
