class Field < ActiveRecord::Base
  belongs_to :field_definition
  belongs_to :medical_template
  belongs_to :task
  belongs_to :ucum_entry, :class_name => "UcumEntry" , :foreign_key => "ucum_entry_id"
  has_one :measured_value
end
