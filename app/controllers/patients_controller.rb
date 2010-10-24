class PatientsController < ApplicationController

  RESULTSPERPAGE = 3

  # GET /patients
  # GET /patients.xml
  def index
    return false unless authorize(permissions = ["view_patient"])

    session[:origin] = params[:origin] if params.has_key?(:origin)
    
    @patients = Patient.paginate :page => params[:page], :order => 'family_name ASC', :per_page => RESULTSPERPAGE

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patients }
    end
  end

  def admission
    return false unless authorize(permissions = ["view_patient"])

    session[:origin] = params[:origin] if params.has_key?(:origin)

    @patients = Patient.paginate :page => params[:page], :order => 'family_name ASC', :per_page => RESULTSPERPAGE

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patients }
    end
  end

  # GET /patients/1
  # GET /patients/1.xml
  def show
    return false unless authorize(permissions = ["view_patient"])

    @patient = Patient.find(params[:id])
    #@comment = @patient.comments.build(params[:comment])
    @comments = Comment.paginate :page => params[:page], :order => 'created_at DESC', :conditions => { :patient_id => params[:id] }
    #@posts = Post.paginate :page => params[:page], :order => 'created_at DESC'
    session[:active_patient_id] = @patient.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  def comment
    return false unless authorize(permissions = ["create_comment"])
    mycomment = params[:comment]
    if mycomment[:comment].blank?
      flash.now[:error] = t('patient.messages.comment_blank')
    else
      Patient.find(params[:id]).comments.create(params[:comment])
      flash.now[:notice] = t('patient.messages.comment_added')
    end
    redirect_to :action => "show", :id => params[:id]
  end
  

  # GET /patients/new
  # GET /patients/new.xml
  def new
    return false unless authorize(permissions = ["create_patient"])

    @patient = Patient.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  # GET /patients/1/edit
  def edit
    return false unless authorize(permissions = ["edit_patient"])
    @patient = Patient.find(params[:id])
  end

  # POST /patients
  # POST /patients.xml
  def create
    return false unless authorize(permissions = ["create_patient"])

    @patient = Patient.new(params[:patient])
    @case_file = CaseFile.new(:entry_date => Date.today())

    if @case_file.save
      @patient.active_case_file_id = @case_file.id

      respond_to do |format|
        if @patient.save

          session[:active_patient_id] = @patient.id

          @case_file.update_attributes(:patient_id => @patient.id)
          flash.now[:notice] = t("patient.messages.create_success")
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
    return false unless authorize(permissions = ["edit_patient"])

    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        flash.now[:notice] = t("patient.messages.update_success")
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
    return false unless authorize(permissions = ["delete_patient"])
    
    @patient = Patient.find(params[:id])
    
    if @patient.destroy
      flash.now[:notice] = t("patient.messages.delete_success")

      if session[:active_patient_id] == @patient.id
        session[:active_patient_id] = nil
      end

    end

    respond_to do |format|
      format.html { redirect_to(patients_url) }
      format.xml  { head :ok }
    end
  end

  # search function for ajax search
  def search
    session[:query] = params[:query].strip if params[:query]

    if session[:query]
      if session[:query] == ""
        @patients = Patient.paginate :page => params[:page], :order => 'family_name ASC', :per_page => RESULTSPERPAGE
      else
        patientname = session[:query]
#          patientname.each_line(' ') { |namepart|
#            @patients = Patient.paginate :page => params[:page],:per_page => RESULTSPERPAGE,
#            :conditions => ["first_name LIKE ? or family_name LIKE ?", "%#{namepart}%","%#{namepart}%"], :order => "family_name ASC"}
        patient_namepart_arrays = Array.new
        i = 0
        patientname.split(' ').each do |patternpart|
          if patternpart != ""
            patients_of_partname=Patient.all :select => 'id',:conditions => ["first_name LIKE ? or family_name LIKE ?" , "%#{patternpart}%","%#{patternpart}%"], :order => "family_name ASC"

            patient_namepart_arrays[i]=Array.new
            patients_of_partname.each do |patient|
              patient_namepart_arrays[i].push patient.id
            end
            i = i+1
          end
        end
          if patient_namepart_arrays.empty?
            @patients = []
          else
            patient_ids = patient_namepart_arrays[0]
            patient_namepart_arrays.each do |patientarray|
              patient_ids = patientarray & patient_ids
            end
            @patients=Patient.paginate :page => params[:page],:per_page => RESULTSPERPAGE, :conditions => { :id => patient_ids }
          end
      end
    end

    if request.xhr?
         render :partial => "patients/patient_search_results", :layout => false, :locals => {:searchresults => @patients}
    else
        respond_to do |format|
        format.html # search.haml
        format.xml  { render :xml => @patient }
        end
    end

   end


end
