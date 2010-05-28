class UcumEntry < Entry
  has_many :fields
  has_many :field_definitions , :foreign_key => "example_ucum_id"
end