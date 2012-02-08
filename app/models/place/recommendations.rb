module Place::Recommendations
  
  def update_recommendations_count
    self.update_attribute(:recommendations_count, Recommendation.where("place_id" => self.id).count)
  end
  
  def add_recommender(user, opts=[])
    Recommendation.create(:user => user, :place => self, :is_owner => opts.include?(:owner), :is_verified => opts.include?(:verified))
  end
  
  def recommended_by?(user)
    return false if user.nil?
    !self.recommendations.where("user_id = ?", user.id).empty?
  end
  
  def change_recommendation_status_for(user, status)
    recommend = self.recommendations.where("user_id = ?", user.id)
    if(recommend.empty? && status.to_sym == :on)
      self.add_recommender(user)
    elsif(!recommend.empty? && status.to_sym == :off)
      return false if recommend.first.is_owner
      recommend.first.delete
      update_recommendations_count
    end
  end
  
  # Ownings code
  
  def verified_owner_is?(user)
    return false if user.nil?
    !self.recommendations.where("user_id = ? AND is_owner = ? AND is_verified = ?", user.id, true, true).empty?
  end
  
  def owned_by?(user)
    return false if user.nil?
    !self.recommendations.where("user_id = ? AND is_owner = ?", user.id, true).empty?
  end
  
  def owners
    Recommendation.find(:all, :conditions => {:is_owner => true}, :include => :user)
  end
  
  def get_any_owner
    owner= owners.first
    return owner.user unless owner.nil?
    nil
  end
end