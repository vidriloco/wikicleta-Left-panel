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

ActiveRecord::Schema.define(:version => 20120311080330) do

  create_table "admins", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

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

  create_table "answers", :force => true do |t|
    t.integer  "meta_answer_option_id"
    t.integer  "meta_answer_item_id"
    t.integer  "survey_id"
    t.string   "open_value"
    t.integer  "question_id"
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

  create_table "bike_items", :force => true do |t|
    t.integer  "category"
    t.string   "name"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cataloged_answers", :force => true do |t|
    t.string   "content"
    t.integer  "cataloged_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cataloged_questions", :force => true do |t|
    t.string   "content"
    t.integer  "order"
    t.string   "model_klass"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "standard_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["standard_name"], :name => "standard_name_index", :unique => true

  create_table "incidents", :force => true do |t|
    t.string   "description"
    t.integer  "kind"
    t.integer  "bike_item_id"
    t.boolean  "complaint_issued"
    t.string   "bike_description"
    t.string   "vehicle_identifier"
    t.datetime "date_and_time"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.point    "coordinates",        :limit => nil, :srid => 4326
  end

  create_table "meta_answer_items", :force => true do |t|
    t.integer  "meta_question_id"
    t.string   "human_value"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_answer_options", :force => true do |t|
    t.integer  "meta_question_id"
    t.string   "human_value"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_questions", :force => true do |t|
    t.integer  "meta_survey_id"
    t.string   "title"
    t.string   "instruction"
    t.string   "order_identifier"
    t.string   "type_of"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_surveys", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "question_answer_rank_counts", :force => true do |t|
    t.integer  "total",               :default => 0
    t.integer  "cataloged_answer_id"
    t.integer  "ranked_count_id"
    t.string   "ranked_count_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_answer_rank_counts", ["cataloged_answer_id", "ranked_count_id", "ranked_count_type"], :name => "question_answer_rank_counts_idx", :unique => true

  create_table "question_answer_ranks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cataloged_answer_id"
    t.integer  "cataloged_question_id"
    t.integer  "open_number",           :default => 0
    t.integer  "ranked_id"
    t.string   "ranked_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_answer_ranks", ["user_id", "cataloged_question_id", "ranked_id", "ranked_type"], :name => "question_answer_ranks_idx", :unique => true

  create_table "questions", :force => true do |t|
    t.integer  "meta_question_id"
    t.integer  "survey_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommendations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.boolean  "is_owner",    :default => false
    t.boolean  "is_verified", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "street_marks", :force => true do |t|
    t.string      "name"
    t.integer     "user_id"
    t.datetime    "created_at"
    t.datetime    "updated_at"
    t.line_string "segment_path", :limit => nil, :srid => 4326
  end

  create_table "surveys", :force => true do |t|
    t.integer  "meta_survey_id"
    t.integer  "evaluable_id"
    t.string   "evaluable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
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
