require Rails.root.join('lib','evaluations')

Evaluations.setup do |config|  
  config.open_question_types = ["MOQ", "OQ", "MOSM"]
end