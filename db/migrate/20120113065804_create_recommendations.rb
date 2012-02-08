class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.integer :place_id
      t.boolean :is_owner, :default => :false
      t.boolean :is_verified, :default => :false
      t.timestamps
    end
  end
end
