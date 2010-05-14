class Entry < ActiveRecord::Base
  belongs_to :node
end

class FieldEntry < Entry
 # has_one :field_definition
end

class UCUMEntry < Entry
 # has_many :fields
 # has_many :field_definitions
end

class ICDEntry < Entry
  # has_many :diagnoses
end

class ATCEntry < Entry
  # has_many :medications
end

class OPSEntry < Entry
  # has_many :treatments
end