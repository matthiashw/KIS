class Medication < ActiveRecord::Base
  belongs_to :atc_entry, :class_name => "AtcEntry" , :foreign_key => "atc_entry_id"
  belongs_to :treatment

  validates_presence_of :atc_entry
end
