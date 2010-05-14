class Diagnosis < ActiveRecord::Base
   belongs_to :icd_entry, :class_name => "Entry" , :foreign_key => "icd_entry_id"
   belongs_to :user
   belongs_to :case
   has_and_belongs_to_many :treatments
end
