class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.integer :mobility_kindness_index
      t.text :description
      t.string :address
      t.integer :category_id
      t.string :twitter
      t.point :coordinates, :srid => 4326, :with_z => false 
      
      t.boolean :is_bike_friendly
      t.integer :recommendations_count, :default => 0
      t.integer :photos_count, :default => 0
      t.integer :comments_count, :default => 0
      t.timestamps
    end
  end
end
