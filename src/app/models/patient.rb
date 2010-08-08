class Patient < ActiveRecord::Base
  validates_presence_of :active_case_file_id, :first_name, :family_name,
                        :birthdate, :address, :sex, :phone
  has_many :case_files
  has_many :comments
  has_many :medical_reports
  belongs_to :extern_medication_treatment , :class_name => "Treatment" , :foreign_key => "extern_medication_treatment_id"
  belongs_to :active_case_file , :class_name => "CaseFile" , :foreign_key => "active_case_file_id"

end
