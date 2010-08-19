class AppointmentsController < ApplicationController
  # GET /appointments
  # GET /appointments.xml
  def index
    return false unless authorize(permissions = ["view_appointment"])
    @appointments = Appointment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @appointments }
    end
  end

  # GET /appointments/1
  # GET /appointments/1.xml
  def show
    return false unless authorize(permissions = ["view_appointment"])
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @appointment }
    end
  end

  # GET /appointments/new
  # GET /appointments/new.xml
  def new
    return false unless authorize(permissions = ["create_appointment"])
    @appointment = Appointment.new
    @tasks = get_tasks
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @appointment }
    end
  end

  # GET /appointments/1/edit
  def edit
    return false unless authorize(permissions = ["edit_appointment"])
    @appointment = Appointment.find(params[:id])
    @tasks = get_tasks
  end

  # POST /appointments
  # POST /appointments.xml
  def create
    return false unless authorize(permissions = ["create_appointment"])
    @appointment = Appointment.new(params[:appointment])
    @tasks = get_tasks
    
    respond_to do |format|
      if @appointment.save
        flash.now[:notice] = t('appointment.messages.create_success')
        format.html { redirect_to(@appointment) }
        format.xml  { render :xml => @appointment, :status => :created, :location => @appointment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @appointment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /appointments/1
  # PUT /appointments/1.xml
  def update
    return false unless authorize(permissions = ["edit_appointment"])
    @appointment = Appointment.find(params[:id])
    @tasks = get_tasks

    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
        flash.now[:notice] = t('appointment.messages.update_success')
        format.html { redirect_to(@appointment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @appointment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.xml
  def destroy
    return false unless authorize(permissions = ["delete_appointment"])
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to(appointments_url) }
      format.xml  { head :ok }
    end
  end

  def calendar
    return false unless authorize(permissions = ["view_appointment"])
    @month = params[:month].to_i
    @year = params[:year].to_i

    @shown_month = Date.civil(@year, @month)

    @appointments = Appointment.all

    #first day of week where Sunday is 0, Monday is 1...
    @first_day_of_week = 1;
    @event_strips = Appointment.event_strips_for_month(@shown_month, @first_day_of_week)
  end

  def get_tasks
    Task.find(:all, :order => 'state ASC, deadline ASC', :conditions => { :creator_user_id => current_user.id })
  end
end
