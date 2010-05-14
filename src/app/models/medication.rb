class Medication < ActiveRecord::Base
  belongs_to :atc_entry, :class_name => "Entry" , :foreign_key => "atc_entry_id"
  belongs_to :treatment
end
