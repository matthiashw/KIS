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
    @catalog = CatalogManager.instance.catalog 'treat'

    if session.has_key?(:active_patient_id)
      @current_active_patient = Patient.find(session[:active_patient_id])
    else
      @current_active_patient = nil
    end

    if session.has_key?(:origin)
      session[:origin] = nil
    end

    @tasks = Task.all

    respond_to do |format|
    
      format.html # new.html.erb
      format.xml  { render :xml => @treatment }
   
     end
  end

  def new_step2
    @treatment = Treatment.new

    @catalog = CatalogManager.instance.catalog 'atc'
    @current_active_patient = Patient.find(session[:active_patient_id])

    respond_to do |format|

      format.html # new.html.erb
      format.xml  { render :xml => @treatment }

     end
  end

  # GET /treatments/1/edit
  def edit
    @catalog = CatalogManager.instance.catalog 'treat'
    @treatment = Treatment.find(params[:id])
  end

  # POST /treatments
  # POST /treatments.xml
  def create
    @treatment = Treatment.new(params[:treatment])
    @treatment.case_file_id = params[:case_file_id]
    @treatment.ops_entry_id = params[:opscode]

    respond_to do |format|
      if @treatment.save
        flash[:notice] = 'Treatment was successfully created.'
        format.html { redirect_to patient_case_file_treatment_path(:patient_id => params[:patient_id], :case_file_id => @treatment.case_file_id, :id => @treatment) }
        format.xml  { render :xml => @treatment, :status => :created, :location => @treatment }
      else
        format.html { render :action => "new" }
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
end
