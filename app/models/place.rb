class Place < ActiveRecord::Base
  include Follows
  include Comments
  include Geography
  
  has_many :follows
  has_many :followers, :through => :follows, :source => :user
  
  has_many :announcements
  
  has_many :place_comments
  has_many :commenters, :through => :place_comments, :source => :user
  
  belongs_to :category
  
  validates_presence_of :name, :description, :category
  validate :coordinates_are_set, :twitter_correct_format

  def self.with_comments(id)
    self.find(:first, :conditions => {:id => id}, :include => :commenters)
  end

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
  
end
