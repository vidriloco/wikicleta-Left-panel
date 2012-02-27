class CreateBikeItems < ActiveRecord::Migration
  def change
    create_table :bike_items do |t|
      t.integer :category
      t.string :name
      t.string :details
      t.timestamps
    end
  end
end
