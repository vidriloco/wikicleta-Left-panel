class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :meta_survey_id
      t.references :evaluable, :polymorphic => true
      t.integer :user_id
      t.timestamps
    end
  end
end
