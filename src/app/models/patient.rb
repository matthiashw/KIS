class Patient < ActiveRecord::Base
  has_many :cases
  has_many :comments
  belongs_to :extern_medication_treatment , :class_name => "Treatment" , :foreign_key => "extern_medication_treatment_id"
  belongs_to :active_case , :class_name => "Case" , :foreign_key => "active_case_id"
end
