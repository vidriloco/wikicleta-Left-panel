class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :place_id
      t.boolean :is_owner, :default => :false
      t.timestamps
    end
  end
end
