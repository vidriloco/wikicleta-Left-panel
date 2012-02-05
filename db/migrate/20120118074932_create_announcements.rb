class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :header
      t.string :message
      t.datetime :start_date
      t.datetime :end_date
      t.integer :place_id
      t.integer :user_id
      t.timestamps
    end
  end
end
