class CreateCatalogedQuestions < ActiveRecord::Migration
  def change
    create_table :cataloged_questions do |t|
      t.string :content
      t.integer :order
      t.string :model_klass
      t.timestamps 
    end
  end
end
