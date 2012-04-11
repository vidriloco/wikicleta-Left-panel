# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120403000018) do

  create_table "admins", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "admins_idx", :unique => true

  create_table "announcements", :force => true do |t|
    t.string   "header"
    t.string   "message"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "place_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "secret"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["provider", "uid"], :name => "authorizations_provider_uid_idx", :unique => true
  add_index "authorizations", ["provider", "user_id"], :name => "authorizations_provider_user_id_idx", :unique => true

  create_table "bike_brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bikes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "kind"
    t.integer  "bike_brand_id"
    t.string   "frame_number"
    t.integer  "user_id"
    t.string   "main_photo_file_name"
    t.string   "main_photo_content_type"
    t.integer  "main_photo_file_size"
    t.datetime "main_photo_updated_at"
    t.integer  "likes_count",             :default => 0
    t.integer  "share_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "incidents", :force => true do |t|
    t.string   "description"
    t.integer  "kind"
    t.boolean  "complaint_issued"
    t.integer  "lock_used"
    t.string   "vehicle_identifier"
    t.date     "date"
    t.time     "start_hour"
    t.time     "final_hour"
    t.integer  "user_id"
    t.integer  "bike_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.point    "coordinates",        :limit => nil, :srid => 4326
  end

  create_table "place_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.integer  "mobility_kindness_index"
    t.text     "description"
    t.string   "address"
    t.integer  "category_id"
    t.string   "twitter"
    t.boolean  "is_bike_friendly"
    t.integer  "recommendations_count",                  :default => 0
    t.integer  "photos_count",                           :default => 0
    t.integer  "comments_count",                         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.point    "coordinates",             :limit => nil,                :srid => 4326
  end

  create_table "recommendations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.boolean  "is_owner",    :default => false
    t.boolean  "is_verified", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "street_mark_rankings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "street_mark_id"
    t.integer  "aspect_1"
    t.integer  "aspect_2"
    t.integer  "aspect_3"
    t.integer  "aspect_4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "street_mark_rankings", ["street_mark_id", "user_id"], :name => "street_mark_rankings_idx", :unique => true

  create_table "street_marks", :force => true do |t|
    t.string      "name"
    t.integer     "user_id"
    t.datetime    "created_at"
    t.datetime    "updated_at"
    t.line_string "segment_path", :limit => nil, :srid => 4326
  end

  create_table "user_like_bikes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bike_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_like_bikes", ["user_id", "bike_id"], :name => "uniqueness_likes_idx", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "full_name"
    t.string   "username"
    t.text     "bio"
    t.string   "personal_page"
    t.boolean  "share_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
