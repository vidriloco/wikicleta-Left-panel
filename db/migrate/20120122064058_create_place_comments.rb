class CreatePlaceComments < ActiveRecord::Migration
  def change
    create_table :place_comments do |t|
      t.integer :user_id
      t.integer :place_id
      t.string :content
      t.timestamps
    end
  end
end
