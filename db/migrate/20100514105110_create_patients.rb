class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients do |t|
      t.string :first_name
      t.string :family_name
      t.date :birthdate
      t.text :address
      t.string :sex
      t.string :phone
      t.integer :active_case_id
      t.integer :extern_medication_treatment_id
      t.timestamps
    end
  end

  def self.down
    drop_table :patients
  end
end
