class DiagTreatFix < ActiveRecord::Migration
  def self.up
    rename_table('treatments_diagnoses', 'diagnoses_treatments')
  end

  def self.down
    rename_table('diagnoses_treatments', 'treatments_diagnoses')
  end
end
