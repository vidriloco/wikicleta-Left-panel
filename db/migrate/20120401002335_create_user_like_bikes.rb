class CreateUserLikeBikes < ActiveRecord::Migration
  def change
    create_table :user_like_bikes do |t|
      t.integer :user_id
      t.integer :bike_id
      t.timestamps
    end
    
    add_index :user_like_bikes, [:user_id, :bike_id], :unique => true, :name => "uniqueness_likes_idx"
  end
end
