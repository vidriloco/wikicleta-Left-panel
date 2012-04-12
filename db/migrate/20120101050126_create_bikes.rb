class CreateBikes < ActiveRecord::Migration
  def change
    create_table :bikes do |t|
      t.string      :name
      t.string      :description
      t.integer     :kind
      t.integer     :bike_brand_id
      t.string      :frame_number
      t.integer     :user_id
      
      t.string      :main_photo_file_name
      t.string      :main_photo_content_type
      t.integer     :main_photo_file_size
      t.datetime    :main_photo_updated_at
      
      t.integer     :likes_count, :default => 0
      
      # for bike sharing mode
      t.integer     :sharing_mode
      t.boolean     :is_available
      t.float       :sharing_fee
      t.point       :coordinates, :srid => 4326, :with_z => false
      t.float       :weight
      
      t.timestamps
    end
  end
end
