
class MedicalReportsController < ApplicationController
  # GET /medical_reports
  # GET /medical_reports.xml
  def index
    return false unless authorize(permissions = ["view_medical_report"])
    @medical_reports = MedicalReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @medical_reports }
    end
  end

  # GET /medical_reports/1
  # GET /medical_reports/1.xml
  def show
    return false unless authorize(permissions = ["view_medical_report"])
    @medical_report = MedicalReport.find(params[:id])

    @config = YAML::load(File.open("#{RAILS_ROOT}/config/report.yml"))
    @header = ReportHeader.find_by_id(@config["header"])

    @htmlOutput = @medical_report.file
    @breakPos = 0

    while true
      @breakPos = @htmlOutput.index('page-break-after', @breakPos)
     
      if @breakPos == nil
        break
      end

      @endBreak   = @htmlOutput.index('</div>', @breakPos) +6
      @htmlOutput = @htmlOutput[0,@endBreak]+ @header.html + @htmlOutput[@endBreak,@htmlOutput.length]
      
      @breakPos += @header.html.length
    end
    
    if @header != nil
      @medical_report.file = @header.html + @htmlOutput
    else
      @medical_report.file = @htmlOutput
    end
    
   

    respond_to do |format|
      format.html
      #format.html {render :layout => 'medical_report'}# show.html.erb
      format.xml  { render :xml => @medical_report }
    end
  end


  # GET /medical_reports/new
  # GET /medical_reports/new.xml
  def new
    return false unless authorize(permissions = ["create_medical_report"])
    @medical_report = MedicalReport.new
    @patient = Patient.find(session[:active_patient_id])
    
    @case_files = CaseFile.find_all_by_patient_id(session[:active_patient_id])
    
    @properties = Array.new
    @properties.push(MedicalReportsProperties.new(1, "anamnesis"));
    @properties.push(MedicalReportsProperties.new(2, "findings"));
    @properties.push(MedicalReportsProperties.new(3, "diagnoses"));
    @properties.push(MedicalReportsProperties.new(4, "treatments"));


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @medical_report }
    end
  end

  # GET /medical_reports/1/edit
  def edit
    return false unless authorize(permissions = ["edit_medical_report"])
    @medical_report = MedicalReport.find(params[:id])
  end

  # POST /medical_reports
  # POST /medical_reports.xml
  def create
    return false unless authorize(permissions = ["create_medical_report"])
    @medical_report = MedicalReport.new(params[:medical_report])
    @patient = Patient.find(session[:active_patient_id])

    @cases = Array.new
    params[:special][:CaseFile].each { |item|
      @cases.push CaseFile.find(item)
    }

    @cached_content = ActionView::Base.new(Rails::Configuration.new.view_path).render(
      :partial => "medical_reports/report",
      :patient => @patient,
      :locals => {:page => self,
                  :patient => @patient,
                  :case_files => @cases,
                  :properties => params[:special][:MedicalReportsProperties]})

    
    @medical_report.file = @cached_content

    respond_to do |format|
      if @medical_report.save
        flash.now[:notice] = 'MedicalReport was successfully created.'
        format.html { redirect_to(@medical_report) }
        format.xml  { render :xml => @medical_report, :status => :created, :location => @medical_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @medical_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /medical_reports/1
  # PUT /medical_reports/1.xml
  def update
    return false unless authorize(permissions = ["edit_medical_report"])
    @medical_report = MedicalReport.find(params[:id])

    respond_to do |format|
      if @medical_report.update_attributes(params[:medical_report])
        flash.now[:notice] = 'MedicalReport was successfully updated.'
        format.html { redirect_to(@medical_report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @medical_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /medical_reports/1
  # DELETE /medical_reports/1.xml
  def destroy
    return false unless authorize(permissions = ["delete_medical_report"])
    @medical_report = MedicalReport.find(params[:id])
    @medical_report.destroy

    respond_to do |format|
      format.html { redirect_to(medical_reports_url) }
      format.xml  { head :ok }
    end
  end
end

class MedicalReportsProperties
  def initialize(id, name)
    @name     = name
    @id       = id
  end

  def id
    return @id
  end

  def name
    return @name
  end
end
