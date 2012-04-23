class CreateBikes < ActiveRecord::Migration
  def change
    create_table :bikes do |t|
      t.string      :name
      t.string      :description
      t.integer     :kind
      t.integer     :bike_brand_id
      t.string      :frame_number
      t.integer     :user_id
      t.float       :weight
      t.point       :coordinates, :srid => 4326, :with_z => false
      t.integer     :main_picture
      t.string      :model
      
      t.integer     :likes_count, :default => 0
      t.timestamps
    end
  end
end
