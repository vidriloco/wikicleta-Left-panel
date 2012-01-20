class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :message
      t.boolean :is_temporal
      t.datetime :start_date
      t.datetime :end_date
      t.integer :place_id
      t.timestamps
    end
  end
end
