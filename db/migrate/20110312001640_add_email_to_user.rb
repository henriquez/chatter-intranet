class AddEmailToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string
  end

  def self.down
  end
end
