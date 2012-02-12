class Place < ActiveRecord::Base
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
  
  belongs_to :category
  has_many :surveys, :as => :evaluable
  
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
  
  def evaluation_count_for(meta_answer_item) 
    self.surveys.joins(:answers).where(
                                    :answers => 
                                      {:meta_answer_item_id => meta_answer_item.id},
                                    :surveys => 
                                      {:evaluable_id => self.id, :evaluable_type => self.class.to_s}).count
  end
  
end
