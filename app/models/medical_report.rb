class MedicalReport < ActiveRecord::Base
  belongs_to :patient
  validates_presence_of :description
end
