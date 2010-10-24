class CaseFile < ActiveRecord::Base
  belongs_to :patient
  has_many :treatments
  has_many :diagnoses
  has_many :tasks

  validates_presence_of :entry_date

  #set the new casefile active for patient
  #true if success
  def setactive
    patient = Patient.find(patient_id)
    if patient.update_attributes(:active_case_file_id => id)
      return true
    else
      return false
    end
  end
  
end
