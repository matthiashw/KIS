class CreateDiagnoses < ActiveRecord::Migration
  def self.up
    create_table :diagnoses do |t|
      t.string :description
      t.integer :icd_entry_id
      t.integer :user_id
      t.integer :case_id

      t.timestamps
    end
    create_table :treatments_diagnoses, :id => false do |t|
      t.integer :treatment_id
      t.integer :diagnosis_id
    end

  end

  def self.down
    drop_table :diagnoses
    drop_table :treatments_diagnoses
  end
end
