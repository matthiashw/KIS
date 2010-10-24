class CreateTreatments < ActiveRecord::Migration
  def self.up
    create_table :treatments do |t|
      t.text :description
      t.date :start_date
      t.integer :case_id
      t.integer :user_id
      t.integer :ops_entry_id
      t.integer :task_id
      t.timestamps
    end
  end

  def self.down
    drop_table :treatments
  end
end
