class CreateCatalogedAnswers < ActiveRecord::Migration
  def change
    create_table :cataloged_answers do |t|
      t.string :content
      t.integer :cataloged_question_id
      t.timestamps
    end
    
    require 'factory_girl_rails'
    Factory(:cars_speed)
    Factory(:comfortable)
  end
end
