class Treatment < ActiveRecord::Base
  #has_one :patient  # Fraglich ob das Sinn macht
  belogns_to :case
  has_and_belongs_to_many :diagnoses
  belongs_to :ops_entry , :class_name => "Entry" , :foreign_key => ops_entry_id
  has_many :medications
  belongs_to :task
  belogns_to :user
end
