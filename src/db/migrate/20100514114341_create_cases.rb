class CreateCases < ActiveRecord::Migration
  def self.up
    create_table :cases do |t|
      t.date :entry_date
      t.date :leave_date
      t.integer :patient_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cases
  end
end
