class CreateMedications < ActiveRecord::Migration
  def self.up
    create_table :medications do |t|
      t.text :description
      t.integer :atc_entry_id
      t.integer :treatment_id

      t.timestamps
    end
  end

  def self.down
    drop_table :medications
  end
end
