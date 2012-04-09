class User < ActiveRecord::Base
  has_many :authorizations, :dependent => :destroy
  has_many :bikes
  has_many :user_like_bikes
  has_many :comments
  
  has_many :recommendations
  has_many :places, :through => :recommendations
  
  has_many :place_comments
  has_many :places_commented, :through => :place_comments
  has_many :surveys
  
  has_many :incidents
  has_many :street_marks
  has_many :street_mark_rankings
  
  devise :omniauthable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  attr_accessor :login
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :username, :login, :bio, :personal_page
  validates_presence_of :username, :full_name
  validates_uniqueness_of :username, :email
  
  def owns_comment?(comment)
    return false if comment.nil?
    comment.user == self
  end
  
  def owns_bike?(bike)
    return false if bike.nil?
    bike.user == self
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end
  
  def self.new_from_oauth_params(hash)
    case hash["provider"]
      when "twitter"
        info = hash["info"]
        new(:full_name => info["name"], :username => info["nickname"])
      when "facebook"
        info = hash["extra"]["raw_info"]
        new(:full_name => info["name"], :email => info["email"])
    end
  end
  
  def add_authorization(session)
    generated_password = Devise.friendly_token.first(8)
    self.password, self.password_confirmation = [generated_password]*2
    self.authorizations.build(session)
  end
  
  def check_parameters_and_password(hash)
    return self.valid_password?(hash["current_password"]) if hash.has_key?("current_password")
    true
  end

end
