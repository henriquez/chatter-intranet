class CreateNotifiers < ActiveRecord::Migration
  def self.up
    create_table :notifiers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :notifiers
  end
end
