class Place < ActiveRecord::Base
  include Shared::Geography
  include Opinions
  include Recommendations
  include Comments
  include Announcements
  include Geography
  include Search
  
  has_many :recommendations
  has_many :recommenders, :through => :recommendations, :source => :user
  
  has_many :announcements
  
  has_many :place_comments
  has_many :commenters, :through => :place_comments, :source => :user
    
  validates_presence_of :name, :description, :category
  validate :coordinates_are_set, :twitter_correct_format
  
  def self.include_with(id, association)
    self.find(:first, :conditions => {:id => id}, :include => association)
  end

  def self.filtering_with(sort_order, categories=[])
    category_conds = {:category_id => categories}
    return Place.where(category_conds).order("mobility_kindness_index DESC") if(sort_order.to_s == "accessible")
    return Place.where(category_conds).order("created_at DESC") if(sort_order.to_s == "recent")
    return Place.where(category_conds).order("recommendations_count DESC") if(sort_order.to_s == "most_recommended")
    return Place.where(category_conds).order("mobility_kindness_index DESC, created_at ASC")
  end
  
  def self.new_with_owner(params, user)
    new_place = self.new(params)
    new_place.recommendations.build(:user => user, :is_owner => true, :place => new_place)
    new_place
  end
  
  def evaluation_from(user)
    Survey.where({:user_id => user.id, :evaluable_id => self.id, :evaluable_type => self.class.to_s}).first
  end
  
  def is_bike_friendly?
    is_bike_friendly
  end
  
  def evaluation_count_for(meta_answer_item) 
    self.surveys.joins(:answers).where(
                                    :answers => 
                                      {:meta_answer_item_id => meta_answer_item.id},
                                    :surveys => 
                                      {:evaluable_id => self.id, :evaluable_type => self.class.to_s}).count
  end
  
  private
  def twitter_correct_format
    return true if self.twitter.blank?
    errors.add(:base, I18n.t('places.custom_validations.twitter_bad_format')) if !self.twitter.match(/@(\w+)/).nil?
  end
  
end
