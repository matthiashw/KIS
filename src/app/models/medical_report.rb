class MedicalReport < ActiveRecord::Base
  belongs_to :patient
end
