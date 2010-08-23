class PatientHistoriesController < ApplicationController
    # GET /tasks
  # GET /tasks.xml
  def index
    #return authorize unless task_authorize?('view_all_tasks', 'view_domain_task', 'view_own_task')

    respond_to do |format|
      @domain = Domain.find_by_name ("anamnesis")

      if params.has_key?("change")
        @task = Task.find(params[:change])
        @templates = MedicalTemplate.find_all_by_domain_id(@domain.id)
        format.html # anamnesecreation
        format.xml  { render :xml => @task }
      else

        if session.has_key?(:active_patient_id)
          @current_active_patient = Patient.find(session[:active_patient_id])
          @cases = CaseFile.find_all_by_patient_id(@current_active_patient.id)
          @cases.each do |c|
            @anamnesis = Task.find_by_case_file_id_and_domain_id(c.id,@domain.id)
            unless @anamnesis.nil?
              break
            end
          end

          if @anamnesis.nil?
            @task = Task.new
            @templates = MedicalTemplate.find_all_by_domain_id(@domain.id)

            format.html # anamnesecreation
            format.xml  { render :xml => @task }
          else
            format.html { redirect_to :action => "fill", :id => @anamnesis.id}
            format.xml  { redirect_to :action => "fill", :id => @anamnesis.id}
          end
        else
          format.html { redirect_to  :controller => "patients"}
          format.xml  { render :xml => @task }

        end
      end
    end
  end

  #create all stuff needed for fillanamnesis view
  def createhistoryfields

    respond_to do |format|
    @task = Task.find(params[:id])
    @selectedfields = params[:fields]
    unless @task.nil?
      unless @selectedfields.nil?
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
                  :task_id => @task.id, :ucum_entry_id => fieldDef.example_ucum_id)
              end

              unless field.save
                format.html { redirect_to :action => "index" }
                format.xml  { render :xml => field.errors, :status => :unprocessable_entity }
              end

            end
          end
          format.html { redirect_to :action => "fill", :id => @task.id}
          format.xml  { redirect_to :action => "fill", :id => @task.id}
    else
      @task = Task.new(params[:task])
      @task.state = Task.state_open
      @task.creator_user_id = current_user.id
      @domain = Domain.find_by_name ("anamnesis")
      @task.domain_id = @domain.id

      if session.has_key?(:active_patient_id)
        @current_active_patient = Patient.find(session[:active_patient_id])
        @task.case_file_id = @current_active_patient.active_case_file_id
      end


        if @task.save
          unless @selectedfields.nil?
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
                  :task_id => @task.id, :ucum_entry_id => fieldDef.example_ucum_id)
              end

              unless field.save
                @task.destroy
                format.html { redirect_to :action => "index" }
                format.xml  { render :xml => field.errors, :status => :unprocessable_entity }
              end

            end
          end

          format.html { redirect_to :action => "fill", :id => @task.id}
          format.xml  { redirect_to :action => "fill", :id => @task.id}
        else
          flash[:error] = "Patient History could not be saved!"
          format.html { redirect_to :action => "index" }
          format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  #fillanamnesis view controller - do fieldshashstuff
  def fill
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.state == Task.state_closed

       flash[:error] = t('task.messages.state_closed')
       format.html { redirect_to :action => "index" }
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

          format.html # fill.haml
          format.xml  { render :xml => @task }

    end
  end

  #creates entries for anamnesis
  def createhistoryentries
    @task = Task.find(params[:id])
      @values = params[:values]
      @comments = params[:comments]

      respond_to do |format|

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

            @task.update_attribute(:state, Task.state_inprogress)

        flash[:notice] = "Patient History saved"
        format.html { redirect_to :action => "fill", :id => @task.id}
        format.xml  { redirect_to :action => "fill", :id => @task.id}
      else
        flash[:error] = "Patient History could not be saved!"
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end
end