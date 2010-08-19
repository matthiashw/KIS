class CaseFilesController < ApplicationController

  # GET /case_files
  # GET /case_files.xml
  def index
    return false unless authorize(permissions = ["view_casefile"])

    @case_files = CaseFile.find_all_by_patient_id(session[:active_patient_id],:order => 'entry_date DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_files }
    end
  end

  # GET /case_files/1
  # GET /case_files/1.xml
  def show
    return false unless authorize(permissions = ["view_casefile"])

    @case_file = CaseFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @case_file }
    end
  end

  # GET /case_files/new
  # GET /case_files/new.xml
  def new
    return false unless authorize(permissions = ["create_casefile"])

    @case_file = CaseFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case_file }
    end
  end

  # GET /case_files/1/edit
  def edit
  return false unless authorize(permissions = ["edit_casefile"])

    @case_file = CaseFile.find(params[:id])
  end

  # POST /case_files
  # POST /case_files.xml
  def create
    return false unless authorize(permissions = ["create_casefile"])

    @case_file = CaseFile.new(params[:case_file])

    respond_to do |format|
        if session[:active_patient_id]
          @case_file.patient_id = session[:active_patient_id]

          if @case_file.save

            @case_file.setactive

            casefiles = CaseFile.find_all_by_leave_date(nil)
            casefiles.each do |casefile|
              unless @case_file == casefile  
                casefile.update_attributes(:leave_date => Date.today)
              end
            end
            

            flash.now[:notice] = t("case_file.messages.success")
            format.html { redirect_to patient_case_file_path(:patient_id => params[:patient_id], :id => @case_file.id) }
            format.xml  { render :xml => @case_file, :status => :created, :location => @case_file }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @case_file.errors, :status => :unprocessable_entity }
          end

        else
            flash.now[:error] = t("case_file.messages.no_active_patient")
            format.html { render :action => "new" }
            format.xml  { head :error  }
        end
    end
  end

  # PUT /case_files/1
  # PUT /case_files/1.xml
  def update
    return false unless authorize(permissions = ["update_casefile"])

    @case_file = CaseFile.find(params[:id])

    respond_to do |format|
      if @case_file.update_attributes(params[:case_file])
        flash.now[:notice] = t("case_file.messages.update_success")
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
    return false unless authorize(permissions = ["destroy_casefile"])

    @case_file = CaseFile.find(params[:id])
    @case_file.destroy

    respond_to do |format|
      format.html { redirect_to(patient_case_files_url) }
      format.xml  { head :ok }
    end
  end

  #activates a case for view
  def setcaseforview
    return false unless authorize(permissions = ["setactive_casefile"])

    casefile = CaseFile.find(params[:id])
    session[:case_view_id] = casefile.id unless casefile.nil?

    flash.now[:notice] = t("case_file.messages.activated")

    respond_to do |format|
        format.html { redirect_to(patient_case_files_url)  }
        format.xml  { head :ok }
      end
  end
  
end
