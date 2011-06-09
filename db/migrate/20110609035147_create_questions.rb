class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :feed_item_id
      t.integer :comment_total
      t.string    :name
      t.string   :email

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
