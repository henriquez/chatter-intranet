class CreateUserThumbnail < ActiveRecord::Migration
  def self.up
    add_column :users, :profile_thumbnail_url, :string
  end

  def self.down
  end
end
