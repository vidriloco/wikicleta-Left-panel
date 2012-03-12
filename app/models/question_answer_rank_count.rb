class QuestionAnswerRankCount < ActiveRecord::Base
  belongs_to :cataloged_answer
  
  def self.increment(params)
    self.update_by(1, params)
  end
  
  def self.decrement(params)
    self.update_by(-1, params)
  end
  
  private
  def self.update_by(number, params)
    counter = QuestionAnswerRankCount.first(:conditions => params)
    if counter.nil?
      QuestionAnswerRankCount.create({:total => 1}.merge(params))
    else
      counter.update_attribute(:total, counter.total+number)
    end
  end
end
