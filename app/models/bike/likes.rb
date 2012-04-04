module Bike::Likes
  
  def register_like_from(user)
    user_like_bike=UserLikeBike.create(:user => user, :bike => self)
    
    if user_like_bike.persisted?
      update_likes_count_by(1)
    end
  end
  
  def destroy_like_from(user)
    user_likes_bike=find_user_likes_bike(user, self)
    unless user_likes_bike.nil?
      user_likes_bike.destroy
      
      if user_likes_bike.destroyed?
        update_likes_count_by(-1)
      end
    end
  end
  
  def is_liked_by?(user)
    return "requires_login weak" if user.nil?
    UserLikeBike.status_for_pair(user, self)
  end
    
  private
  
  def find_user_likes_bike(user, bike)
    UserLikeBike.find_by_user_id_and_bike_id(user.id, bike.id)
  end
  
  def update_likes_count_by(number)
    update_attribute(:likes_count,  likes_count+number) 
  end
end