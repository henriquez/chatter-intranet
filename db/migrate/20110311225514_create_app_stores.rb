class CreateAppStores < ActiveRecord::Migration
  def self.up
    create_table :app_stores do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :app_stores
  end
end
