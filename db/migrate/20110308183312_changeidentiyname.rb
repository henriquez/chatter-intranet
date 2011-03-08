class Changeidentiyname < ActiveRecord::Migration
  def self.up
    rename_column :users, :identiy_url, :identity_url
  end

  def self.down
  end
end
