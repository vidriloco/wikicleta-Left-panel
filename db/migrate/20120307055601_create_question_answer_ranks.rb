class CreateQuestionAnswerRanks < ActiveRecord::Migration
  def change
    create_table :question_answer_ranks do |t|
      t.integer :user_id
      t.integer :cataloged_answer_id
      t.integer :cataloged_question_id
      t.integer :open_number, :default => 0
      t.references :ranked, :polymorphic => true
      t.timestamps
    end
    
    add_index(:question_answer_ranks, [:user_id, :cataloged_question_id, :ranked_id, :ranked_type], :unique => true, :name => 'question_answer_ranks_idx')
    
  end
end
