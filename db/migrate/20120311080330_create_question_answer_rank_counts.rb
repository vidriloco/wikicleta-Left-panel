class CreateQuestionAnswerRankCounts < ActiveRecord::Migration
  def change
    create_table :question_answer_rank_counts do |t|
      t.integer :total, :default => 0
      t.integer :cataloged_answer_id
      t.references :ranked_count, :polymorphic => true
      t.timestamps
    end
    
    add_index(:question_answer_rank_counts, [:cataloged_answer_id, :ranked_count_id, :ranked_count_type], :unique => true, :name => 'question_answer_rank_counts_idx')
    
  end
end
