class DiagnosesController < ApplicationController
  # GET /diagnoses
  # GET /diagnoses.xml
  def index
    return false unless authorize(permissions = ["view_diagnosis"])
    @diagnoses = Diagnosis.find_all_by_case_file_id(params[:case_file_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @diagnoses }
    end
  end

  # GET /diagnoses/1
  # GET /diagnoses/1.xml
  def show
    return false unless authorize(permissions = ["view_diagnosis"])
    @diagnosis = Diagnosis.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diagnosis }
    end
  end

  # GET /diagnoses/new
  # GET /diagnoses/new.xml
  def new
    return false unless authorize(permissions = ["create_diagnosis"])
    @diagnosis = Diagnosis.new
    @catalog = CatalogManager.instance.catalog 'diagnosis'
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diagnosis }
    end
  end

  # GET /diagnoses/1/edit
  def edit
    return false unless authorize(permissions = ["edit_diagnosis"])
    @diagnosis = Diagnosis.find(params[:id])
    @catalog = CatalogManager.instance.catalog 'diagnosis'
  end

  # POST /diagnoses
  # POST /diagnoses.xml
  def create
    return false unless authorize(permissions = ["create_diagnosis"])
    @diagnosis = Diagnosis.new(params[:diagnosis])
    @diagnosis.case_file_id = params[:case_file_id]
    @diagnosis.icd_entry_id = params[:icdcode]
    @diagnosis.user = current_user
    @catalog = CatalogManager.instance.catalog 'diagnosis'
    respond_to do |format|
      if @diagnosis.save
        flash.now[:notice] = t('diagnosis.messages.create_success')
        format.html {redirect_to patient_case_file_diagnosis_path(:patient_id => params[:patient_id], :case_file_id => @diagnosis.case_file_id, :id => @diagnosis) }
        format.xml  { render :xml => @diagnosis, :status => :created, :location => @diagnosis }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diagnosis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /diagnoses/1
  # PUT /diagnoses/1.xml
  def update
    return false unless authorize(permissions = ["edit_diagnosis"])
    @diagnosis = Diagnosis.find(params[:id])
    @diagnosis.icd_entry_id = params[:icdcode]
    @catalog = CatalogManager.instance.catalog 'diagnosis'
    respond_to do |format|
      if @diagnosis.update_attributes(params[:diagnosis])
        flash.now[:notice] = t('diagnosis.messages.update_success')
        format.html { redirect_to patient_case_file_diagnosis_path(:patient_id => params[:patient_id], :case_file_id => @diagnosis.case_file_id, :id => @diagnosis) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diagnosis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /diagnoses/1
  # DELETE /diagnoses/1.xml
  def destroy
    return false unless authorize(permissions = ["delete_diagnosis"])
    @diagnosis = Diagnosis.find(params[:id])
    @diagnosis.destroy

    respond_to do |format|
      format.html { redirect_to patient_case_file_diagnoses_path(:patient_id => params[:patient_id], :case_file_id => @diagnosis.case_file_id) }
      format.xml  { head :ok }
    end
  end
end
