class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.date :deadline
      t.text :creator_comment
      t.text :executor_comment
      t.integer :state
      t.integer :case_id
      t.integer :domain_id
      t.integer :creator_user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
