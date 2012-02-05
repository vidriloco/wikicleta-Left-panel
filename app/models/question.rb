class Question < ActiveRecord::Base
  
  def self.create_default(rule, text)
    Question.create(:category_type => rule, :text => text)
  end

end
