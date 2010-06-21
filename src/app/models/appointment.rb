class Appointment < ActiveRecord::Base

  belongs_to :user
  belongs_to :task

  validates_presence_of :start_date, :end_date, :name

  has_event_calendar :start_at_field  => 'start_date', :end_at_field => 'end_date'
end
