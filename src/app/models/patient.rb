class Patient < ActiveRecord::Base
  has_many :case_files
  has_many :comments
  belongs_to :extern_medication_treatment , :class_name => "Treatment" , :foreign_key => "extern_medication_treatment_id"
  belongs_to :active_case_file , :class_name => "CaseFile" , :foreign_key => "active_case_file_id"
end
