class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates_presence_of :start_date, :end_date, :name
end
