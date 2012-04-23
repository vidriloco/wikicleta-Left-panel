class Bike < ActiveRecord::Base
  include Categories
  include Likes
  
  acts_as_commentable
  
  has_many :user_like_bikes, :dependent => :destroy
  has_many :bike_statuses, :dependent => :destroy
  has_many :pictures, :as => :imageable, :dependent => :destroy

  #has_many :tweaks
  #has_many :borrows
  #has_many :usage_days
  #mileage
  belongs_to :bike_brand
  belongs_to :user
  
  validates_presence_of :name, :kind, :bike_brand, :user
    
  scope :most_popular, order('likes_count DESC')
  scope :all_from_user, lambda { |user| where("user_id = ?", user.id) } 
  
  def front_picture
    begin
      return Picture.find(self.main_picture)
    rescue
      nil
    end
  end
  
  def brand
    return if bike_brand.nil?
    bike_brand.name
  end
  
  def owner
    return if user.nil?
    user.username
  end
  
  def contact
    return "---" if(user.nil? || user.email.blank?)
    user.email
  end
  
  def self.new_with_owner(params, owner)
    new(params.merge(:user => owner))
  end
  
  def update_attributes_with_owner(params, owner)
    return self.update_attributes(params) if self.user = owner
    false
  end
  
end
