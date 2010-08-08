class Task < ActiveRecord::Base
  has_many :fields
  has_many :measured_values
  belongs_to :case_file
  has_many :uploaded_files
  has_one :treatment
  belongs_to :domain
  belongs_to :creator,:class_name => "User", :foreign_key => "creator_user_id"
end
