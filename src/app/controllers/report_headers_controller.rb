class ReportHeadersController < ApplicationController
  # GET /report_headers
  # GET /report_headers.xml
  def index
    @report_headers = ReportHeader.all

    @config = YAML::load(File.open("#{RAILS_ROOT}/config/report.yml"))
    @standard = ReportHeader.find_by_id(@config["header"])
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @report_headers }
    end
  end

  def standard
    @config = YAML::load(File.open("#{RAILS_ROOT}/config/report.yml"))
    @config["header"] = params[:id]
    File.open("#{RAILS_ROOT}/config/report.yml", 'w') { |f| YAML.dump(@config, f) }

    respond_to do |format|
      format.html { redirect_to(report_headers_url) }
      format.xml  { render :xml => @report_headers }
    end
  end

  # GET /report_headers/1
  # GET /report_headers/1.xml
  def show
    @report_header = ReportHeader.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report_header }
    end
  end

  # GET /report_headers/new
  # GET /report_headers/new.xml
  def new
    @report_header = ReportHeader.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_header }
    end
  end

  # GET /report_headers/1/edit
  def edit
    @report_header = ReportHeader.find(params[:id])
  end

  # POST /report_headers
  # POST /report_headers.xml
  def create
    @report_header = ReportHeader.new(params[:report_header])

    respond_to do |format|
      if @report_header.save
        flash[:notice] = 'ReportHeader was successfully created.'
        format.html { redirect_to(@report_header) }
        format.xml  { render :xml => @report_header, :status => :created, :location => @report_header }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_header.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_headers/1
  # PUT /report_headers/1.xml
  def update
    @report_header = ReportHeader.find(params[:id])

    respond_to do |format|
      if @report_header.update_attributes(params[:report_header])
        flash[:notice] = 'ReportHeader was successfully updated.'
        format.html { redirect_to(@report_header) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_header.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_headers/1
  # DELETE /report_headers/1.xml
  def destroy
    @report_header = ReportHeader.find(params[:id])
    @report_header.destroy

    respond_to do |format|
      format.html { redirect_to(report_headers_url) }
      format.xml  { head :ok }
    end
  end
end
