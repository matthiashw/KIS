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
    @treatment = Treatment.new
    @catalog = CatalogManager.instance.catalog 'treat'
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
        flash.now[:notice] = 'Treatment was successfully created.'
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
        flash.now[:notice] = 'Treatment was successfully updated.'
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
