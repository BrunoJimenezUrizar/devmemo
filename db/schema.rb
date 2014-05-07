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

ActiveRecord::Schema.define(:version => 20131204220537) do

  create_table "advertises", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "active"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "image_advertise_file_name"
    t.string   "image_advertise_content_type"
    t.integer  "image_advertise_file_size"
    t.string   "name"
    t.string   "link"
  end

  create_table "areapoints", :force => true do |t|
    t.integer  "area_id"
    t.integer  "point_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.integer  "points_area_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "attendees", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "mobile_user_id"
    t.integer  "event_id"
  end

  create_table "buildings", :force => true do |t|
    t.integer  "campus_id"
    t.string   "name"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.spatial  "polygon",            :limit => {:srid=>4326, :type=>"polygon", :geographic=>true}, :null => false
    t.spatial  "center_coordinates", :limit => {:srid=>4326, :type=>"point", :geographic=>true},   :null => false
  end

  create_table "campus_surveys", :force => true do |t|
    t.integer  "campus_id"
    t.integer  "question_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "campusadvertisings", :force => true do |t|
    t.integer "campus_id"
    t.integer "advertise_id"
  end

  create_table "campuses", :force => true do |t|
    t.string   "name"
    t.integer  "university_id"
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.spatial  "polygon",             :limit => {:srid=>4326, :type=>"polygon", :geographic=>true}
    t.string   "address"
    t.spatial  "address_coordinates", :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.spatial  "center_coordinates",  :limit => {:srid=>4326, :type=>"point", :geographic=>true}
  end

  create_table "campuses_question_groups", :id => false, :force => true do |t|
    t.integer  "campus_id"
    t.integer  "question_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "campusreportings", :force => true do |t|
    t.integer "campus_id"
    t.integer "report_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "logo"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "university_id"
  end

  create_table "categorizations", :force => true do |t|
    t.integer  "category_id"
    t.integer  "poi_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "event_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "complaint_id"
    t.integer  "user_id"
    t.boolean  "public"
    t.text     "body"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "complaint_types", :force => true do |t|
    t.integer  "university_id"
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "complaints", :force => true do |t|
    t.text     "description"
    t.string   "status"
    t.integer  "campus_id"
    t.integer  "mobile_user_id"
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
    t.integer  "complaint_type_id"
    t.spatial  "coordinates",        :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
  end

  create_table "dumps", :force => true do |t|
    t.string   "description"
    t.string   "qr_code"
    t.integer  "type_id"
    t.integer  "por_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "visits",      :default => 0
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "start_advertising"
    t.datetime "end_advertising"
    t.integer  "campus_id"
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.spatial  "coordinates",        :limit => {:srid=>4326, :type=>"point", :geographic=>true}, :null => false
  end

  create_table "floors", :force => true do |t|
    t.integer  "building_id"
    t.integer  "number"
    t.string   "indoor_path"
    t.text     "description"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "indoor_path_file_name"
    t.string   "indoor_path_content_type"
    t.integer  "indoor_path_file_size"
    t.datetime "indoor_path_updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "levels", :force => true do |t|
    t.string   "name"
    t.integer  "points"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "mobile_users", :force => true do |t|
    t.string   "email"
    t.string   "api_token"
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "access_token"
    t.string   "last_name"
    t.string   "link"
    t.string   "fb_id"
    t.string   "nickname"
    t.string   "profile_picture_url"
    t.date     "birthday"
    t.string   "gender"
    t.integer  "score",               :default => 0
  end

  create_table "points", :force => true do |t|
    t.string   "location"
    t.string   "name"
    t.string   "description"
    t.integer  "type_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.decimal  "latitude"
    t.decimal  "longitude"
  end

  create_table "points_areas", :force => true do |t|
    t.integer  "point_id"
    t.integer  "area_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pois", :force => true do |t|
    t.integer  "campus_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.spatial  "coordinates", :limit => {:srid=>4326, :type=>"point", :geographic=>true}, :null => false
  end

  create_table "pors", :force => true do |t|
    t.integer  "campus_id"
    t.text     "name"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.spatial  "coordinates", :limit => {:srid=>4326, :type=>"point", :geographic=>true}, :null => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "survey_id"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rapidfire_answer_groups", :force => true do |t|
    t.integer  "question_group_id"
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "mobile_user_id"
  end

  create_table "rapidfire_answers", :force => true do |t|
    t.integer  "answer_group_id"
    t.integer  "question_id"
    t.text     "answer_text"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "rapidfire_campus_question_groups", :id => false, :force => true do |t|
    t.integer  "campus_id"
    t.integer  "question_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "rapidfire_question_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "active",             :default => false
    t.integer  "campus_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "university_id"
  end

  create_table "rapidfire_questions", :force => true do |t|
    t.integer  "question_group_id"
    t.string   "type"
    t.string   "question_text"
    t.integer  "position"
    t.text     "answer_options"
    t.text     "validation_rules"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "recycle_infos", :force => true do |t|
    t.integer  "mobile_user_id"
    t.integer  "dump_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "university_id"
    t.integer  "campus_id"
    t.integer  "type_id"
    t.integer  "por_id"
  end

  create_table "reports", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "active"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "image_report_file_name"
    t.string   "image_report_content_type"
    t.integer  "image_report_file_size"
    t.string   "name"
    t.string   "link"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "surveys", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.integer  "campus_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "types", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "university_id"
  end

  create_table "universities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "acronym"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "usercampuses", :force => true do |t|
    t.integer "campus_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

end
