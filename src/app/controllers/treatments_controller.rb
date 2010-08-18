class TreatmentsController < ApplicationController
  #layout 'application'

  # GET /treatments
  # GET /treatments.xml
  def index
    @treatments = Treatment.find_all_by_case_file_id(params[:case_file_id])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @treatments }
    end
  end

  # GET /treatments/1
  # GET /treatments/1.xml
  def show
    @treatment = Treatment.find(params[:id])
    #@case_file = CaseFile.find(@treatment.case_file_id);
    #@patient = Patient.find(@case_file.patient_id);

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @treatment }
    end
  end

  # GET /treatments/new
  # GET /treatments/new.xml
  def new
    @current_stage = "step_1"
    @catalog = CatalogManager.instance.catalog 'treat'
    @treatment = Treatment.new
    
    if session.has_key?(:active_patient_id)
      @current_active_patient = Patient.find(session[:active_patient_id])
    else
      @current_active_patient = nil
    end

    if session.has_key?(:origin)
      session[:origin] = nil
    end

    @tasks = Task.all

    save_partial_treatment_in_session

    respond_to do |format|
    
      format.html # new.html.erb
      format.xml  { render :xml => @treatment }
   
     end
  end

  def new_step2
    get_partial_treatment_from_session

    @current_stage = "step_2"
    
    @catalog = CatalogManager.instance.catalog 'atc'
    @current_active_patient = Patient.find(session[:active_patient_id])

    respond_to do |format|
      if session.has_key?(:active_patient_id)

        if params[:current_stage] == 'step_1'
          @treatment.case_file_id = get_case_for_view

          if params[:task][:id] == "" and not params[:skip]
            flash[:error] = 'Please select a valid task'
            format.html { redirect_to :action => "new" }
            format.xml  { render :xml => @treatment }
          else
            @treatment.task_id = params[:task][:id]
            format.html # taskcreation.html.erb
            format.xml  { render :xml => @treatment }
          end
          
        else
          
          format.html # taskcreation.html.erb
          format.xml  { render :xml => @treatment }

        end

      else
           flash[:error] = 'No active Patient'
           format.html { redirect_to :action => "new" }
           format.xml  { render :xml => @treatment }
      end
    end

    save_partial_treatment_in_session
  end

  def new_step3
    get_partial_treatment_from_session

    @current_stage = "step_3"
    @current_active_patient = Patient.find(session[:active_patient_id])

    respond_to do |format|
      if session.has_key?(:active_patient_id)
        if params[:current_stage] == 'step_2'
          if (params[:continue])
            if params[:medications] == ""
              flash[:error] = 'Please select a valid medication'
              format.html { redirect_to :action => "new_step2" }
              format.xml  { render :xml => @treatment }
            else
              @medIds = params[:medications].split(",").collect{ |s| s.to_i }

              @medIds.each {|x|
                @medication = Medication.new(:atc_entry_id => x)

                @treatment.medications = @treatment.medications.concat([@medication])
              }

              format.html # taskcreation.html.erb
              format.xml  { render :xml => @treatment }
            end
          elsif params[:skip]
            format.html { redirect_to :action => "new_step4" }
            format.xml  { render :xml => @treatment }
          end
        else
          format.html # taskcreation.html.erb
          format.xml  { render :xml => @treatment }
        end
      else
        flash[:error] = 'No active Patient'
           format.html { redirect_to :action => "new" }
           format.xml  { render :xml => @treatment }
      end
    end

    save_partial_treatment_in_session
  end

  def new_step4
    get_partial_treatment_from_session
    
    @current_stage = "step_4"
    @current_active_patient = Patient.find(session[:active_patient_id])
    @catalog = CatalogManager.instance.catalog 'ops'

    respond_to do |format|
      if session.has_key?(:active_patient_id)
        if params[:current_stage] == 'step_3'
          i = 0
          while i < params[:description].length
            @treatment.medications[i].description = params[:description][i]
            i += 1
          end

        end
        
        format.html # taskcreation.html.erb
        format.xml  { render :xml => @treatment }
      else
       flash[:error] = 'No active Patient'
       format.html { redirect_to :action => "new" }
       format.xml  { render :xml => @treatment }
      end
    end

    save_partial_treatment_in_session
  end

  def new_step5
    get_partial_treatment_from_session
    
    @current_active_patient = Patient.find(session[:active_patient_id])
    @diagnoses = Diagnosis.find_all_by_case_file_id get_case_for_view

    respond_to do |format|
      if session.has_key?(:active_patient_id)
        if params[:current_stage] == 'step_4'
          if params[:treatment] == "" and not params[:skip]
            flash[:error] = 'Please select a valid task'
            format.html { redirect_to :action => "new_step4" }
            format.xml  { render :xml => @treatment }
          elsif params[:skip]
            format.html # taskcreation.html.erb
            format.xml  { render :xml => @treatment }
          else
            @treatment.ops_entry = OpsEntry.find(params[:treatment])
            format.html # taskcreation.html.erb
            format.xml  { render :xml => @treatment }
          end
        else
          format.html # taskcreation.html.erb
          format.xml  { render :xml => @treatment }
        end
      else
        flash[:error] = 'No active Patient'
           format.html { redirect_to :action => "new" }
           format.xml  { render :xml => @treatment }
      end
    end

    save_partial_treatment_in_session
  end

  # GET /treatments/1/edit
  def edit
    @diagnoses = Diagnosis.find_all_by_case_file_id get_case_for_view
    @catalog = CatalogManager.instance.catalog 'ops'
    @treatment = Treatment.find(params[:id])
  end

  # POST /treatments
  # POST /treatments.xml
  def create
    get_partial_treatment_from_session
    
    @current_active_patient = Patient.find(session[:active_patient_id])
    @diagnoses = Diagnosis.find_all_by_case_file_id get_case_for_view
    @treatment.update_attributes(params[:treatment])

    respond_to do |format|
      if @treatment.save
        flash[:notice] = 'Treatment was successfully created.'
        format.html { redirect_to patient_case_file_treatment_path(:patient_id => params[:patient_id], :case_file_id => @treatment.case_file_id, :id => @treatment) }
        format.xml  { render :xml => @treatment, :status => :created, :location => @treatment }
      else
        format.html { render :action => "new_step5" }
        format.xml  { render :xml => @treatment.errors, :status => :unprocessable_entity }
      end
    end
  end

  

  # PUT /treatments/1
  # PUT /treatments/1.xml
  def update
    @treatment = Treatment.find(params[:id])
    @treatment.ops_entry_id = params[:opscode]

    respond_to do |format|
      if @treatment.update_attributes(params[:treatment])
        flash[:notice] = 'Treatment was successfully updated.'
        format.html { redirect_to patient_case_file_treatment_path(:patient_id => params[:patient_id], :case_file_id => @treatment.case_file_id, :id => @treatment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @treatment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /treatments/1
  # DELETE /treatments/1.xml
  def destroy
    @treatment = Treatment.find(params[:id])
    @treatment.destroy

    respond_to do |format|
      format.html { redirect_to(treatments_url) }
      format.xml  { head :ok }
    end
  end

  def get_partial_treatment_from_session
      unless session[:partial_treatment].nil?
        @treatment = session[:partial_treatment]
      else
        @treatment = Treatment.new
      end
    end

  def save_partial_treatment_in_session
    unless @treatment.nil?
      session[:partial_treatment] = @treatment
    end
  end


end
