class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = Task.all
    @tasks = Task.paginate :page => params[:page], :order => 'state ASC, deadline ASC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])
    @domain = Domain.find_by_id(@task.domain_id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/taskcreation
  # GET /tasks/taskcreation.xml
  def taskcreation
    @task = Task.new

    respond_to do |format|

      if session.has_key?(:active_patient_id)

        if params[:domain][:id] == ""
          flash[:error] = 'Please select a valid Domain'
          format.html { redirect_to :action => "new" }
          format.xml  { render :xml => @domain }
        else
          @templates = MedicalTemplate.find_all_by_domain_id(params[:domain][:id])
          session[:domain_for_task] = params[:domain][:id]

          format.html # taskcreation.html.erb
          format.xml  { render :xml => @task }
        end
      else
         flash[:error] = 'No active Patient'
         format.html { redirect_to :action => "new" }
         format.xml  { render :xml => @task }
      end

    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    if session.has_key?(:active_patient_id)
      @current_active_patient = Patient.find(session[:active_patient_id])
    else
      @current_active_patient = nil
    end

    if session.has_key?(:origin)
      session[:origin] = nil
    end
    
    @domains = Domain.find_all_by_is_userdomain("1")

     respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @domain }
     end
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
    @task.state = Task.state_open
    @task.creator_user_id = current_user.id
    @selectedfields = params[:fields]
    @comments = params[:comments]

    if session.has_key?(:active_patient_id)
      @current_active_patient = Patient.find(session[:active_patient_id])
      @task.case_file_id = @current_active_patient.active_case_file_id
    end

    if session.has_key?(:domain_for_task)
      @task.domain_id = session[:domain_for_task]
      session[:domain_for_task] = nil
    end

    respond_to do |format|
      if @task.save
        unless @selectedfields.nil?
          @selectedfields.each do |f|
            splittedstr = f.split(';')
            fieldDefId = splittedstr[0]
            fieldDef = FieldDefinition.find(fieldDefId)

            tempId = splittedstr[1]

            if fieldDef.nil?
              field = Field.new(:medical_template_id => tempId, :field_definition_id => fieldDefId,
                                :task_id => @task.id, :comment => @comments[fieldDefId])
            else
              field = Field.new(:medical_template_id => tempId, :field_definition_id => fieldDefId,
                :task_id => @task.id, :ucum_entry_id => fieldDef.example_ucum_id, :comment => @comments[fieldDefId] )
            end

            unless field.save
              @task.destroy
              format.html { render :action => "new" }
              format.xml  { render :xml => field.errors, :status => :unprocessable_entity }
            end

          end
        end

        flash[:notice] = 'Task was successfully created.'
        format.html { redirect_to(@task) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        flash[:error] = 'Task could not be created.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(@task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @fields = Field.find_all_by_task_id(params[:id])


    if @task.destroy
      @fields.each do  |f|
        f.destroy
      end


    end
    flash[:notice] = 'Task was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end

  # method for serving the task filling view
  def taskfill
    @task = Task.find(params[:id])
    @fields = Field.find_all_by_task_id(params[:id])

    #fieldshash stuff is done for processing the fields in the view
    @fieldshash = {}
    @fields.each do |f|
      @fieldshash[f.medical_template_id] ||= {}
      @fieldshash[f.medical_template_id][f.id] ||= f
    end

    respond_to do |format|
      format.html # taskfill.haml
      format.xml  { render :xml => @task }
    end
  end

  #creating measured_values and filling in task info
  def createentries
    @task = Task.find(params[:id])
    @values = params[:values]
    @comments = params[:comments]
     

    respond_to do |format|


        if @task.update_attributes(params[:task])
          unless @values.nil?
            @values.each do |k,v|
              measuredvalue = MeasuredValue.new(:value => v,:comment => @comments[k],
                               :task_id => @task.id, :field_id => k, :medical_template_id => Field.find(k).medical_template_id )
              measuredvalue.save
            end
          end
          
          @task.update_attribute(:state, Task.state_closed)

          flash[:notice] = 'Task successfully completed.'
                format.html { redirect_to(@task) }
                format.xml  { head :ok }

        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
        end


    end
  end

    # for viewing the tasks values and results
    def results
      @task = Task.find(params[:id])
      @values = MeasuredValue.find_all_by_task_id(@task.id)

      #fieldshash stuff is done for processing the fields in the view
      @valueshash = {}
      @values.each do |v|
        @valueshash[v.medical_template_id] ||= {}
        @valueshash[v.medical_template_id][v.id] ||= v
      end

     respond_to do |format|
      format.html # results.haml
      format.xml  { render :xml => @values }
     end
    end
end
