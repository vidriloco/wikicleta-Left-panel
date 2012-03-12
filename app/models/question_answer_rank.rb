class QuestionAnswerRank < ActiveRecord::Base
  belongs_to :cataloged_answer
  belongs_to :cataloged_question
  belongs_to :user
  belongs_to :ranked, :polymorphic => true
  
  after_destroy :decrement_associated_cataloged_answer_count
  after_create :increment_associated_cataloged_answer_count
  
  private
    def params_for_counter_update
      {:ranked_count_id => ranked.id, :ranked_count_type => ranked.class.to_s, :cataloged_answer_id => cataloged_answer.id}
    end
  
    def increment_associated_cataloged_answer_count
      QuestionAnswerRankCount.increment(params_for_counter_update)
    end
    
    def decrement_associated_cataloged_answer_count
      QuestionAnswerRankCount.decrement(params_for_counter_update)
    end
end
