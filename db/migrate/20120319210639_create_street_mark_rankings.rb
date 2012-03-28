class CreateStreetMarkRankings < ActiveRecord::Migration
  def change
    create_table :street_mark_rankings do |t|
      t.integer :user_id
      t.integer :street_mark_id
      t.integer :aspect_1
      t.integer :aspect_2
      t.integer :aspect_3
      t.integer :aspect_4
      t.timestamps
    end
    
    add_index(:street_mark_rankings, [:street_mark_id, :user_id], :unique => true, :name => "street_mark_rankings_idx")
  end
end
