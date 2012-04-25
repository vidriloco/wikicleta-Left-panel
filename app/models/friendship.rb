class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  def reciprocal?
    confirmed
  end
  
  def started_by?(user)
    self.user == user
  end
  
  def opposite_of(user)
    return self.friend if self.user == user
    return self.user
  end
  
  
end
