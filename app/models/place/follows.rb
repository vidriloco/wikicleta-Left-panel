module Place::Follows
  
  def update_followers_count
    self.update_attribute(:followers_count, Follow.where("place_id" => self.id).count)
  end
  
  def add_follower(user)
    Follow.create(:user => user, :place => self)
    update_followers_count
  end
  
  def owned_by?(user)
    return false if user.nil?
    !self.follows.where("user_id = ? AND is_owner = ?", user.id, true).empty?
  end
  
  def followed_by?(user)
    return false if user.nil?
    !self.follows.where("user_id = ?", user.id).empty?
  end
  
  def change_follow_status_for(user, status)
    follow = self.follows.where("user_id = ?", user.id)
    if(follow.empty? && status.to_sym == :on)
      self.add_follower(user)
    elsif(!follow.empty? && status.to_sym == :off)
      return false if follow.first.is_owner
      follow.first.delete
      update_followers_count
    end
  end
  
  def owners
    Follow.find(:all, :conditions => {:is_owner => true}, :include => :user)
  end
  
  def get_any_owner
    owner= owners.first
    return owner.user unless owner.nil?
    nil
  end
end