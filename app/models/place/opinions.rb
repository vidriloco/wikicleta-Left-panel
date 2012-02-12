module Place::Opinions
  
  def evaluation_from(user)
    Survey.where({:user_id => user.id, :evaluable_id => self.id, :evaluable_type => self.class.to_s}).first
  end
  
  def evaluation_count_for(meta_answer_item) 
    self.surveys.joins(:answers).where(
                                    :answers => 
                                      {:meta_answer_item_id => meta_answer_item.id},
                                    :surveys => 
                                      {:evaluable_id => self.id, :evaluable_type => self.class.to_s}).count
  end
end