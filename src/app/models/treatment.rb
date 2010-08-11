class Treatment < ActiveRecord::Base

  belongs_to :case_file
  has_and_belongs_to_many :diagnoses
  belongs_to :ops_entry , :class_name => "OpsEntry" , :foreign_key => "ops_entry_id"
  has_many :medications
  belongs_to :task
  belongs_to :user
  validates_presence_of :description, :start_date, :ops_entry
end
