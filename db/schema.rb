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

ActiveRecord::Schema.define(:version => 20110609035147) do

  create_table "questions", :force => true do |t|
    t.integer  "feed_item_id"
    t.integer  "comment_total"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "users", :force => true do |t|
    t.string "name"
    t.string "instance_url"
    t.string "identity_url"
    t.string "access_token"
    t.string "refresh_token"
    t.string "client_id"
    t.string "user_name"
    t.string "password"
    t.string "crypted_password"
    t.string "login_url"
    t.string "organization_id"
    t.string "user_id"
    t.string "email"
    t.string "profile_thumbnail_url"
  end


end
