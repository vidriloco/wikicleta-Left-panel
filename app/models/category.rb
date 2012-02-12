class Category < ActiveRecord::Base
  has_many :places
  has_one :meta_survey
  
  validates_uniqueness_of :standard_name
  
  def name
    I18n.t("categories.all.#{standard_name}")
  end
  
  def self.set_questions(question_rules)
    question_rules.keys.each do |rule|
      question_rules[rule].each { |question_id| QuestionBlock.create_default(rule, question_id) }
    end
  end
end
