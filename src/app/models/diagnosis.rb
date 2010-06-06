class Diagnosis < ActiveRecord::Base
   belongs_to :icd_entry, :class_name => "IcdEntry" , :foreign_key => "icd_entry_id"
   belongs_to :user
   belongs_to :case_files
   has_and_belongs_to_many :treatments
end
