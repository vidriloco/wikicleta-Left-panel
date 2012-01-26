class PlaceComment < ActiveRecord::Base
  belongs_to :place
  belongs_to :user
  
  validates_presence_of :content
  
  after_destroy :update_places_comment_count
  after_create :update_places_comment_count
  
  def update_places_comment_count
    self.place.update_comments_count
  end
end
