class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  
  after_create :update_place_followers_count
  after_destroy :update_place_followers_count
  
  def update_place_followers_count
    place.update_attribute(:followers_count, Follow.where("place_id" => place.id).count)
  end
end
