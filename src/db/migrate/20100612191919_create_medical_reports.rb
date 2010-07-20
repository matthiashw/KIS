class CreateMedicalReports < ActiveRecord::Migration
  def self.up
    create_table :medical_reports do |t|
      t.text :description
      t.text :file
      t.integer :patient_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :medical_reports
  end
end
