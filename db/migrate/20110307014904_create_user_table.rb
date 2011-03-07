class CreateUserTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :instance_url
      t.string :identiy_url
      t.string :access_token
      t.string :refresh_token
      t.string :client_id
      t.string :user_name
      t.string :password
      t.string :crypted_password
      t.string :login_url
      t.string :organization_id
      t.string :user_id
    end  
  end

  def self.down
  end
end
