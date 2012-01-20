class Place < ActiveRecord::Base
  has_many :follows
  has_many :followers, :through => :follows
  has_many :announcements
  
  belongs_to :category
  
  validates_presence_of :name, :description, :category
  validate :coordinates_are_set, :twitter_correct_format

  def self.filtering_with(sort_order, categories=[])
    category_conds = {:category_id => categories}
    return Place.where(category_conds).order("mobility_kindness_index DESC") if(sort_order.to_s == "accessible")
    return Place.where(category_conds).order("created_at ASC") if(sort_order.to_s == "recent")
    return Place.where(category_conds).order("followers_count DESC") if(sort_order.to_s == "popular")
    return Place.where(category_conds).order("mobility_kindness_index DESC, created_at ASC")
  end
  
  def self.new_with_owner(params, user)
    new_place = self.new(params)
    new_place.follows.build(:user => user, :is_owner => true, :place => new_place)
    new_place
  end
  
  def apply_geo(coordinates)
    return self if coordinates.nil? || (coordinates["lon"].blank? || coordinates["lat"].blank?)
    self.coordinates = Point.from_lon_lat(coordinates["lon"].to_f, coordinates["lat"].to_f, 4326)
    self
  end
  
  def owned_by?(user)
    return false if user.nil?
    !self.follows.where("user_id = ? AND is_owner = ?", user.id, true).empty?
  end
  
  def owners
    Follow.find(:all, :conditions => {:is_owner => true}, :include => :user)
  end
  
  def get_any_owner
    owner= owners.first
    return owner.user unless owner.nil?
    nil
  end
  
  private 
  def coordinates_are_set
    errors.add(:base, I18n.t('places.custom_validations.coordinates_missing')) if self.coordinates.nil?
  end
  
  def twitter_correct_format
    return true if self.twitter.blank?
    errors.add(:twitter, I18n.t('places.custom_validations.twitter_bad_format')) if !self.twitter.match(/@(\w+)/).nil?
  end
end
