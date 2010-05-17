class Field < ActiveRecord::Base
  belongs_to :field_definition
  belongs_to :template
  belongs_to :task
  belongs_to :ucum_entry, :class_name => "Entry" , :foreign_key => "ucum_entry_id"
  has_one :measured_value
end
