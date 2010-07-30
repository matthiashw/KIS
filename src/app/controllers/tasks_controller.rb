class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new
    @templates = MedicalTemplate.find_all_by_domain_id(2)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
    @selectedfields = params[:fields]

    respond_to do |format|
      if @task.save

        @selectedfields.each do |f|
          splittedstr = f.split(';')
          fieldDefId = splittedstr[0]
          fieldDef = FieldDefinition.find(fieldDefId)

          tempId = splittedstr[1]

          if fieldDef.nil?
            field = Field.new(:medical_template_id => tempId, :field_definition_id => fieldDefId,
                              :task_id => @task.id)
          else
            field = Field.new(:medical_template_id => tempId, :field_definition_id => fieldDefId,
              :task_id => @task.id, :ucum_entry_id => fieldDef.example_ucum_id )
          end

          unless field.save
            format.html { render :action => "new" }
            format.xml  { render :xml => field.errors, :status => :unprocessable_entity }
          end

        end

        flash[:notice] = 'Task was successfully created.'
        format.html { redirect_to(@task) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
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
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
end
