class CreateChatouts < ActiveRecord::Migration
  def self.up
    create_table :chatouts do |t|
      t.text
      t.timestamps
    end
  end

  def self.down
    drop_table :chatouts
  end
end
