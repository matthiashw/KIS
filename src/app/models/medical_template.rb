class MedicalTemplate < ActiveRecord::Base
  belongs_to :domain
  has_many :measured_values
  has_many :fields
  has_and_belongs_to_many :field_definitions
  belongs_to :catalog
  validates_presence_of :name,:domain
end
