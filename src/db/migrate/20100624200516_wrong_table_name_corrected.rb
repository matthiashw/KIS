class WrongTableNameCorrected < ActiveRecord::Migration
  def self.up
      rename_table :templates_field_definitions, :field_definitions_templates
  end

  def self.down
     rename_table  :field_definitions_templates, :templates_field_definitions
  end
end
