class CalendarController < ApplicationController
  
  def index
    @month = params[:month].to_i
    @year = params[:year].to_i

    @shown_month = Date.civil(@year, @month)

    Event.delete_all()

    appointments = Appointment.all
    appointments.each do |a|
      event = Event.find_or_create_by_event_type_and_type_id("appointment", a.id)

      event.start_at = a.start_date
      event.end_at = a.end_date
      event.name = a.name
      event.color = "#008E00"

      event.save
    end

    @first_day_of_week = 1;
    @event_strips = Event.event_strips_for_month(@shown_month, @first_day_of_week)
  end
  
end