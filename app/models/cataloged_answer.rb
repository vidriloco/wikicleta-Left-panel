class CatalogedAnswer < ActiveRecord::Base
  has_many :ranks
  has_many :question_answer_rank_counts
  
  belongs_to :cataloged_question
end
