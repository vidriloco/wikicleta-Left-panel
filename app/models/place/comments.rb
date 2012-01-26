module Place::Comments
  
  def update_comments_count
    self.update_attribute(:comments_count, PlaceComment.where("place_id" => self.id).count)
  end
  
  def add_comment(user, content)
    PlaceComment.create(:user => user, :place => self, :content => content)
  end
end