class FieldDefinition < ActiveRecord::Base
  belongs_to :field_entry, :class_name => "FieldEntry" , :foreign_key => "field_entry_id"
  belongs_to :example_ucum_entry, :class_name => "UcumEntry" , :foreign_key => "example_ucum_id"
  has_and_belongs_to_many :medical_templates
  has_many :fields
end
