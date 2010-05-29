class CaseFile < ActiveRecord::Base
  belongs_to :patient
  has_many :treatments
  has_many :diagnoses
  has_many :tasks
  
end
