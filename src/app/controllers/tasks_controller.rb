class TasksController < ApplicationController
  before_filter :filter_session, :only => [:search, :mytaskssearch, :domaintaskssearch]

  def filter_session
    session[:selected_task_state] = params[:task_state].strip if params[:task_state]
    session[:selected_task_domain] = params[:task_domain].strip if params[:task_domain]
    session[:selected_task_case] = params[:task_case].strip if params[:task_case]
  end

  # GET /tasks
  # GET /tasks.xml
  def index
    return authorize unless task_authorize?('view_all_tasks', 'view_domain_task', 'view_own_task')

    @tasks = get_tasks

    respond_to do |format|
      format.html # search.haml
      format.xml  { render :xml => @tasks }
    end
  end

  def mytasks
    return false unless authorize(permissions = ["view_own_task"])

    @tasks = get_my_tasks

    respond_to do |format|
      format.html # search.haml
      format.xml  { render :xml => @tasks }
    end
  end

  def domaintasks
    return false unless authorize(permissions = ["view_domain_task"])

    @tasks = get_domain_tasks

    respond_to do |format|
      format.html # search.haml
      format.xml  { render :xml => @tasks }
    end
  end

  def domaintaskssearch

    @tasks = get_domain_tasks

    showmytasks = 2
    if request.xhr?
         render :partial => "task_results", :layout => false, :locals => { :taskresults => @tasks, :showmytasks => showmytasks }
    else
        respond_to do |format|
        format.html # search.haml
        format.xml  { render :xml => @tasks }
        end
    end
  end

  def mytaskssearch

    @tasks = get_my_tasks

    showmytasks = 1
    if request.xhr?
         render :partial => "task_results", :layout => false, :locals => { :taskresults => @tasks, :showmytasks => showmytasks }
    else
        respond_to do |format|
        format.html # search.haml
        format.xml  { render :xml => @tasks }
        end
    end
  end

  def search

    @tasks = get_tasks

    showmytasks = 0
    if request.xhr?
         render :partial => "task_results", :layout => false, :locals => {:taskresults => @tasks, :showmytasks => showmytasks }
    else
        respond_to do |format|
        format.html # search.haml
        format.xml  { render :xml => @tasks }
        end
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])
    return authorize unless task_creator_authorize?(@task.creator_user_id, "view_own_task") || task_authorize?('view_task')

    @domain = Domain.find_by_id(@task.domain_id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/taskcreation
  # GET /tasks/taskcreation.xml
  def taskcreation
    return false unless authorize(permissions = ["create_task"])
    @task = Task.new

    respond_to do |format|

      if session.has_key?(:active_patient_id)

        if params[:domain][:id] == ""
          flash.now[:error] = t('task.messages.select_valid_domain')
          format.html { redirect_to :action => "new" }
          format.xml  { render :xml => @domain }
        else
          @templates = MedicalTemplate.find_all_by_domain_id(params[:domain][:id])
          session[:domain_for_task] = params[:domain][:id]

          format.html # taskcreation.html.erb
          format.xml  { render :xml => @task }
        end
      else
         flash.now[:error] = t('task.messages.no_active_patient')
         format.html { redirect_to :action => "new" }
         format.xml  { render :xml => @task }
      end

    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    return authorize unless task_creator_authorize?(@task.creator_user_id, "edit_own_task") || task_authorize?('edit_task')
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    return false unless authorize(permissions = ["create_task"])
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
    return false unless authorize(permissions = ["create_task"])
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

        flash.now[:notice] = t('task.messages.create_successfull')


        format.html { render :action => "fill", :id => @task.id }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        flash.now[:error] = t('task.messages.create_failed')
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])
    return authorize unless task_creator_authorize?(@task.creator_user_id, "edit_own_task") || task_authorize?('edit_task')

    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash.now[:notice] = t('task.messages.update_successfull')
        if current_active_patient
          format.html { redirect_to patient_task_url(:id => @task.id, :patient_id => current_active_patient.id)  }
        else
          format.html { redirect_to @task }
        end
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
    return authorize unless task_creator_authorize?(@task.creator_user_id, "delete_own_task") || task_authorize?('delete_task')
    @fields = Field.find_all_by_task_id(params[:id])
    @measuredvalues = MeasuredValue.find_all_by_task_id(params[:id])


    if @task.destroy
      @measuredvalues.each do |m|
        m.destroy
      end
      @fields.each do  |f|
        f.destroy
      end


    end
    flash.now[:notice] = t('task.messages.delete_successfull')
    respond_to do |format|
      if current_active_patient
        format.html { redirect_to patient_tasks_url(:patient_id => current_active_patient.id) }
      else
        format.html { redirect_to(tasks_url) }
      end
      
      format.xml  { head :ok }
    end
  end


  # method for serving the task filling view
  def taskfill
    @task = Task.find(params[:id])
    return authorize unless task_domain_authorize?(@task.domain_id, "fill_own_domain_task") || task_authorize?('fill_every_task')

    @taskfiles = UploadedFile.find_all_by_task_id(@task.id)

    respond_to do |format|
      if @task.state == Task.state_closed

       flash.now[:error] = t('task.messages.state_closed')
       format.html { redirect_to :action => "results" }
       format.xml  { render :xml => @task }

      else

        @fields = Field.find_all_by_task_id(params[:id])


        #fieldshash stuff is done for processing the fields in the view
        @fieldshash = {}
        @fields.each do |f|
          @fieldshash[f.medical_template_id] ||= {}
          @fieldshash[f.medical_template_id][f.id] ||= f
        end

       end

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

      if params.has_key?('upload')
        if params.has_key?('file')
          if UploadedFile.savefile(params[:file],@task.id,@comments[:filecomment])
            flash[:notice] = t('task.messages.upload_complete')
          else
            flash[:error] = t('task.messages.upload_failed')
          end

        end
          format.html { redirect_to :action => 'taskfill', :id => @task.id  }
          format.xml  { render :xml => @task}

      else if params.has_key?('delete')
          if UploadedFile.deletefile(params[:delete])
             flash[:notice] = 'ok'
          else
             flash[:notice] = 'not ok'
          end

          format.html { redirect_to :action => 'taskfill', :id => @task.id  }
          format.xml  { render :xml => @task}
      else

        if @task.update_attributes(params[:task])
          unless @values.nil?
            @values.each do |k,v|
              f = Field.find(k)

              unless f.nil?

                  #get value of dropdown for storage(if it is a dropdown field)
                  if FieldDefinition.find(f.field_definition_id).input_type == 3
                    v = InputTypeManager.dropdown_value_return(f.field_definition_id,v)
                  end

                #if the task has allready been filled use existing measured values and update
                if @task.state == Task.state_inprogress

                  measuredvalue = MeasuredValue.find_by_field_id(k)

                  measuredvalue.update_attributes(:value => v,:comment => @comments[k],
                                   :task_id => @task.id, :field_id => k, :medical_template_id => f.medical_template_id )
                else
                  measuredvalue = MeasuredValue.new(:value => v,:comment => @comments[k],
                                   :task_id => @task.id, :field_id => k, :medical_template_id => f.medical_template_id )
                  measuredvalue.save
                end
               end

            end
          end

          if params.has_key?('save')
            @task.update_attribute(:state, Task.state_inprogress)
          end

          if params.has_key?('saveandclose')
            @task.update_attribute(:state, Task.state_closed)
          end

          flash.now[:notice] = t('task.messages.complete_success')
          if current_active_patient
            format.html { redirect_to patient_task_url(:id => @task.id, :patient_id => current_active_patient.id)  }
          else
            format.html { redirect_to @task }
          end
          format.xml  { head :ok }

        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
        end
      end
    end
   end
  end

  # for viewing the tasks values and results
  def results
    @task = Task.find(params[:id])
    return authorize unless task_creator_authorize?(@task.creator_user_id, "show_result_own_task") || task_authorize?('show_result_task')
    @values = MeasuredValue.find_all_by_task_id(@task.id)
    @domain = Domain.find_by_id(@task.domain_id)
    @taskfiles = UploadedFile.find_all_by_task_id(@task.id)

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

  def selected_state
    selected_state = nil

    if session[:selected_task_state]
      if session[:selected_task_state] != "0"
        selected_state = session[:selected_task_state].to_i
      end
    end

    selected_state
  end

  def selected_domain
    selected_domain = nil

    if session[:selected_task_domain]
      if session[:selected_task_domain] != "0"
        selected_domain = session[:selected_task_domain].to_i
      end
    end

    selected_domain
  end

  def selected_case
    selected_case = 1

    if session[:selected_task_case]
      if session[:selected_task_case] == "null"
        selected_case = session[:selected_task_case]
      end
    end

    selected_case
  end

  def task_conditions(*type)
    domain_hash = {}
    state_hash = {}
    case_hash = {}
    own_hash = {}
    own_domain_hash = {}
    
    hash = {}

    active_cases_array = []
    active_cases_hash = {}
    active_case_files = Patient.all

    if !selected_state.nil?
      state_hash = { :state => selected_state }
    end

    if !selected_domain.nil?
      domain_hash = { :domain_id => selected_domain }
    end

    if !get_case_for_view.nil?
      case_hash = { :case_file_id => get_case_for_view }
    end

    if !active_case_files.nil?
      active_case_files.each do |a|
        active_cases_array.push(a.active_case_file_id)
      end
    else

    end

    if selected_case == 1
      if !active_cases_array.empty?
        active_cases_hash = { :case_file_id => active_cases_array }
      end
    elsif selected_case == "null"
        active_cases_hash = {}
    end

    own_hash = { :creator_user_id => current_user.id }
    own_domain_hash = { :domain_id => current_user.domains }

    if !(params[:action] == "mytasks" || params[:action] == "mytaskssearch")
      hash.merge!(case_hash)
    end
    
    hash.merge!(domain_hash)
    hash.merge!(state_hash)

    type.each do |t|
      if t == "all"

      end

      if t == "domain"
        hash.merge!(own_domain_hash)
      end

      if t == "own"
        hash.merge!(own_hash)
      end

      if t == "my"
        hash.merge!(active_cases_hash)
      end

    end

    hash
  end

  def all_tasks
    Task.paginate :page => params[:page], :order => 'state ASC, deadline ASC', :conditions => task_conditions("")
  end

  def domain_tasks
    Task.paginate :page => params[:page], :order => 'state ASC, deadline ASC', :conditions => task_conditions("domain")
  end

  def own_tasks
    Task.paginate :page => params[:page], :order => 'state ASC, deadline ASC', :conditions => task_conditions("own")
  end

  def my_tasks 
    Task.paginate :page => params[:page], :order => 'state ASC, deadline ASC', :conditions => task_conditions("own","my")
  end

  def get_tasks
    if authorize?('view_all_tasks')
      all_tasks
    elsif authorize?('view_domain_task')
      domain_tasks
    elsif authorize?('view_own_task')
      own_tasks
    else
      nil
    end
  end

  def get_my_tasks
    tasks = nil

    if authorize?('view_own_task')
      tasks = my_tasks
    end
    
    tasks
  end

  def get_domain_tasks
    tasks = nil

    if authorize?('view_domain_task')
      tasks = domain_tasks
    end

    tasks
  end
end
