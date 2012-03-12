class CatalogedQuestion < ActiveRecord::Base
  has_many :cataloged_answers
  
  scope :for_street_marks, where(:model_klass => StreetMark.class.to_s)
  
  def stats_for(rankeable)
    compiled_stats=cataloged_answers.each.inject({}) do |collected, last|
      collected.merge!(last.id => last.total)
      collected
    end
    
    { id => compiled_stats }
  end
end
