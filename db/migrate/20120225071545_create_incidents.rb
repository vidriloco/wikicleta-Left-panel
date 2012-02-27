class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string :description
      t.integer :kind
      t.integer :bike_item_id
      t.boolean :complaint_issued
      
      t.string :bike_description
      t.string :vehicle_identifier
      t.point :coordinates, :srid => 4326, :with_z => false 
      t.datetime :date_and_time
      t.integer :user_id
      t.timestamps
    end
  end
end
