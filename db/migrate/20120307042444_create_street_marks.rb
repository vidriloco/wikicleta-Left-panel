class CreateStreetMarks < ActiveRecord::Migration
  def change
    create_table :street_marks do |t|
      t.string :name
      t.line_string :segment_path, :srid => 4326, :with_z => false
      t.integer :user_id 
      t.timestamps
    end
  end
end
