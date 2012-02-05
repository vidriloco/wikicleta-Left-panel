class User < ActiveRecord::Base
  has_many :follows
  has_many :places, :through => :follows
  
  has_many :place_comments
  has_many :places_commented, :through => :place_comments
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :username, :login, :bio, :personal_page
  validates_presence_of :username, :full_name
  validates_uniqueness_of :username
  
  def owns_comment?(comment)
    return false if comment.nil?
    !self.place_comments.where("user_id = ?", self.id).empty?
  end
  
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
