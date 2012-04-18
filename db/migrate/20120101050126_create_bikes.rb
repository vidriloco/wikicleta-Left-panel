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
      
      t.string      :main_photo_file_name
      t.string      :main_photo_content_type
      t.integer     :main_photo_file_size
      t.datetime    :main_photo_updated_at
      
      t.integer     :likes_count, :default => 0
      
      t.point       :coordinates, :srid => 4326, :with_z => false
      
      t.timestamps
    end
  end
end
