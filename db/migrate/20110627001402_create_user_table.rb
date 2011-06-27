class CreateUserTable < ActiveRecord::Migration
  def self.up
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

  def self.down
  end
end
