class UserLikeBike < ActiveRecord::Base
  belongs_to :bike
  belongs_to :user
  
  validates_presence_of :bike, :user
  before_validation :check_uniqueness
  
  def self.status_for_pair(user, bike)
    return "strong" if self.find_by_user_id_and_bike_id(user.id, bike.id)
    "weak"
  end
  
  private
  def check_uniqueness
    errors.add(:base, "Not Unique") if UserLikeBike.find_by_user_id_and_bike_id(user.id, bike.id)
  end
  
end
