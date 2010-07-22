class TemplatesToMedicalTemplates < ActiveRecord::Migration
   def self.up
        rename_table :templates, :medical_templates
        rename_column :field_definitions_templates, :template_id, :medical_template_id
        rename_table :field_definitions_templates, :field_definitions_medical_templates
        rename_column :measured_values, :template_id, :medical_template_id
        rename_column :fields,  :template_id, :medical_template_id
    end
    def self.down
        rename_table :medical_templates, :templates
        rename_table :field_definitions_medical_templates,:field_definitions_templates
        rename_column :field_definitions_templates,:medical_template_id, :template_id
        rename_column :measured_values, :medical_template_id, :template_id
        rename_column :fields, :medical_template_id, :template_id
    end
end
