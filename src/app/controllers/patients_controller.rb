class PatientsController < ApplicationController
  # GET /patients
  # GET /patients.xml
  def index
    return access_denied unless authorize(permissions = ["view_patient"])
    
    @patients = Patient.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patients }
    end
  end

  # GET /patients/1
  # GET /patients/1.xml
  def show
    return access_denied unless authorize(permissions = ["view_patient"])

    @patient = Patient.find(params[:id])

    session[:active_patient_id] = @patient.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.xml
  def new
    return access_denied unless authorize(permissions = ["create_patient"])

    @patient = Patient.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  # GET /patients/1/edit
  def edit
    return access_denied unless authorize(permissions = ["edit_patient"])
    @patient = Patient.find(params[:id])
  end

  # POST /patients
  # POST /patients.xml
  def create
    return access_denied unless authorize(permissions = ["create_patient"])

    @patient = Patient.new(params[:patient])
    @case_file = CaseFile.new(:entry_date => Date.today())

    if @case_file.save
      @patient.active_case_file_id = @case_file.id

      respond_to do |format|
        if @patient.save

          session[:active_patient_id] = @patient.id

          @case_file.update_attributes(:patient_id => @patient.id)
          flash[:notice] = t("patient.create_success")
          format.html { redirect_to(@patient) }
          format.xml  { render :xml => @patient, :status => :created, :location => @patient }
        else
          @case_file.destroy
          format.html { render :action => "new" }
          format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
        end
      end
    else
          format.html { render :action => "new" }
          format.xml  { render :xml => @case_file.errors, :status => :unprocessable_entity }
    end
  end

  # PUT /patients/1
  # PUT /patients/1.xml
  def update
    return access_denied unless authorize(permissions = ["edit_patient"])

    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        flash[:notice] = t("patient.update_success")
        format.html { redirect_to(@patient) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    return access_denied unless authorize(permissions = ["destroy_patient"])
    
    @patient = Patient.find(params[:id])
    
    if @patient.destroy
      flash[:notice] = t("patient.delete_success")
    end

    respond_to do |format|
      format.html { redirect_to(patients_url) }
      format.xml  { head :ok }
    end
  end

  # search function for ajax search
  def search
      if params[:query] and request.xhr?
        if params[:query] == ""
          @patients = Patient.all
        else
          @patients = Patient.find(:all, :conditions => ["first_name LIKE ? or family_name LIKE ?", "%#{params[:query]}%","%#{params[:query]}%"], :order => "family_name ASC")
        end
        render :partial => "shared/patient_search_results", :layout => false, :locals => {:searchresults => @patients}
      end
   end

end
