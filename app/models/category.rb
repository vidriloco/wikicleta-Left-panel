class Category < ActiveRecord::Base
  has_many :places
  
  def self.set_questions(question_rules)
    question_rules.keys.each do |rule|
      question_rules[rule].each { |question_id| QuestionBlock.create_default(rule, question_id) }
    end
  end
end
