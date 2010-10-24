class FieldEntry < Entry
  has_one :field_definition , :dependent => :delete
end