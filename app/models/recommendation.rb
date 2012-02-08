class Recommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  
  after_destroy :update_recommenders_count
  after_create :update_recommenders_count
  
  def update_recommenders_count
    self.place.update_recommendations_count
  end
end
