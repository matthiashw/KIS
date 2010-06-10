class CaseFilesController < ApplicationController


  #marks selected case as active case
  def setactive
    return access_denied unless authorize(permissions = ["setactive_casefile"])

    @case_file = CaseFile.find(params[:id])
    @patient = Patient.find(@case_file.patient_id)

    respond_to do |format|
      if @patient.update_attributes(:active_case_file_id => @case_file.id)
        flash[:notice] = t("case_file.activated")
        format.html { redirect_to(case_files_url)  }
        format.xml  { head :ok }
      else
        flash[:notice] = t("case_file.activated_error")
        format.html { redirect_to(case_files_url)  }
        format.xml  { head :ok }
      end
    end

  end

  # GET /case_files
  # GET /case_files.xml
  def index
    return access_denied unless authorize(permissions = ["view_casefile"])

    @case_files = CaseFile.find_all_by_patient_id(session[:active_patient_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_files }
    end
  end

  # GET /case_files/1
  # GET /case_files/1.xml
  def show
    return access_denied unless authorize(permissions = ["view_casefile"])

    @case_file = CaseFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @case_file }
    end
  end

  # GET /case_files/new
  # GET /case_files/new.xml
  def new
    return access_denied unless authorize(permissions = ["create_casefile"])

    @case_file = CaseFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case_file }
    end
  end

  # GET /case_files/1/edit
  def edit
    return access_denied unless authorize(permissions = ["edit_casefile"])

    @case_file = CaseFile.find(params[:id])
  end

  # POST /case_files
  # POST /case_files.xml
  def create
    return access_denied unless authorize(permissions = ["create_casefile"])

    @case_file = CaseFile.new(params[:case_file])

    respond_to do |format|
        if session[:active_patient_id]
          @case_file.patient_id = session[:active_patient_id]

          if @case_file.save
            flash[:notice] = t("case_file.success")
            format.html { redirect_to(@case_file) }
            format.xml  { render :xml => @case_file, :status => :created, :location => @case_file }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @case_file.errors, :status => :unprocessable_entity }
          end

        else
            flash[:error] = t("case_file.no_active_patient")
            format.html { render :action => "new" }
            format.xml  { head :error  }
        end
    end
  end

  # PUT /case_files/1
  # PUT /case_files/1.xml
  def update
    return access_denied unless authorize(permissions = ["update_casefile"])

    @case_file = CaseFile.find(params[:id])

    respond_to do |format|
      if @case_file.update_attributes(params[:case_file])
        flash[:notice] = t("case.update_success")
        format.html { redirect_to(@case_file) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @case_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /case_files/1
  # DELETE /case_files/1.xml
  def destroy
    return access_denied unless authorize(permissions = ["destroy_casefile"])

    @case_file = CaseFile.find(params[:id])
    @case_file.destroy

    respond_to do |format|
      format.html { redirect_to(case_files_url) }
      format.xml  { head :ok }
    end
  end
  
end
