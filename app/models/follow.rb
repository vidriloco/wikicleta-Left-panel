class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  
  after_destroy :update_followers_count
  after_create :update_followers_count
  
  def update_followers_count
    self.place.update_followers_count
  end
end
