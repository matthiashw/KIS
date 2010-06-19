require 'rubygems'
require 'rtf'
#require 'parsedate'
include RTF

class MedicalReportsController < ApplicationController
  # GET /medical_reports
  # GET /medical_reports.xml
  def index
    @medical_reports = MedicalReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @medical_reports }
    end
  end

  # GET /medical_reports/1
  # GET /medical_reports/1.xml
  def show
    @medical_report = MedicalReport.find(params[:id])

    #File.open("maho15.rtf", 'w') {|file| file.write(@medical_report.file) }
    #send_file "maho15.rtf", :type=>"application/rtf"

    respond_to do |format|
      format.html {render :layout => 'medical_report'}# show.html.erb
      format.xml  { render :xml => @medical_report }
      format.pdf do
        render :pdf => "file_name",
               #template => "medical_reports/show.haml", # OPTIONAL
               :layout => "medical_report", # OPTIONAL
               :show_as_html => !params[:debug].blank? #OPTIONAL, maybe you just want to allow debuging in development environment?
               #:margin => {:top => 10, #OPTIONAL
               #            :bottom  => 10, #OPTIONAL
               #            :left  => 10, #OPTIONAL
               #            :right  => 10}, #OPTIONAL
               #:orientation => 'Landscape or Portrait', #OPTIONAL, default Portrait
               #:page_size => 'A4, Letter, ...', #OPTIONAL, default A4
               #:proxy => 'TEXT', #OPTIONAL
               #:username => 'TEXT', #OPTIONAL
               #:password => 'TEXT', #OPTIONAL
               #:cover => 'URL', #OPTIONAL
               #:dpi => "dpi", #OPTIONAL
               #:encoding => "TEXT", #OPTIONAL
               #:user_style_sheet => "URL", #OPTIONAL
               #:redirect_delay => NUMBER, #OPTIONAL
               #:zoom => FLOAT, #OPTIONAL
               #:page_offset => NUMBER, #OPTIONAL
               #:book => true,  #OPTIONAL
               #:default_header => true,  #OPTIONAL
               #:disable_javascript => true,  #OPTIONAL
               #:greyscale => true,  #OPTIONAL
               #:lowquality => true,  #OPTIONAL
               #:enable_plugins => true,  #OPTIONAL
               #:disable_internal_links => true,  #OPTIONAL
               #:disable_external_links => true,  #OPTIONAL
               #:print_media_type => true,  #OPTIONAL
               #:disable_smart_shrinking => true,  #OPTIONAL
               #:use_xserver => true,  #OPTIONAL
               #:no_background => true,  #OPTIONAL
               #:header => {:html => {:template => "public/header.pdf.erb"}, #OPTIONAL
               #            :center => "TEXT", #OPTIONAL
               #            :font_name => "NAME", #OPTIONAL
               #            :font_size => SIZE, #OPTIONAL
               #            :left => "TEXT", #OPTIONAL
               #            :right => "TEXT", #OPTIONAL
               #            :spacing => REAL, #OPTIONAL
               #            :line => true}, #OPTIONAL
               #:footer => {:html => {:template => "public/header.pdf.erb"}, #OPTIONAL
               #            :center => "TEXT", #OPTIONAL
               #            :font_name => "NAME", #OPTIONAL
               #            :font_size => SIZE, #OPTIONAL
               #            :left => "TEXT", #OPTIONAL
               #            :right => "TEXT", #OPTIONAL
               #            :spacing => REAL, #OPTIONAL
               #            :line => true}, #OPTIONAL
               #:toc => {:font_name => "NAME", #OPTIONAL
               #         :depth => LEVEL, #OPTIONAL
               #         :header_text => "TEXT", #OPTIONAL
               #         :header_fs => SIZE, #OPTIONAL
               #         :l1_font_size => SIZE, #OPTIONAL
               #         :l2_font_size => SIZE, #OPTIONAL
               #         :l3_font_size => SIZE, #OPTIONAL
               #         :l4_font_size => SIZE, #OPTIONAL
               #         :l5_font_size => SIZE, #OPTIONAL
               #         :l6_font_size => SIZE, #OPTIONAL
               #         :l7_font_size => SIZE, #OPTIONAL
               #         :l1_indentation => NUM, #OPTIONAL
               #         :l2_indentation => NUM, #OPTIONAL
               #         :l3_indentation => NUM, #OPTIONAL
               #         :l4_indentation => NUM, #OPTIONAL
               #         :l5_indentation => NUM, #OPTIONAL
               #         :l6_indentation => NUM, #OPTIONAL
               #         :l7_indentation => NUM, #OPTIONAL
               #         :no_dots => true, #OPTIONAL
               #         :disable_links => true, #OPTIONAL
               #         :disable_back_links => true}, #OPTIONAL
               #:outline => {:outline => true, #OPTIONAL
               #             :outline_depth => 1} #OPTIONAL
      end
    end
  end

  # GET /medical_reports/new
  # GET /medical_reports/new.xml
  def new
    @medical_report = MedicalReport.new

    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @medical_report }
    end
  end

  # GET /medical_reports/1/edit
  def edit
    @medical_report = MedicalReport.find(params[:id])
  end

  # POST /medical_reports
  # POST /medical_reports.xml
  def create
    @medical_report = MedicalReport.new(params[:medical_report])
    
    document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'))
    document.paragraph << "This is a short paragraph of text."
    @medical_report.file = document.to_rtf


    respond_to do |format|
      if @medical_report.save
        flash[:notice] = 'MedicalReport was successfully created.'
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
    @medical_report = MedicalReport.find(params[:id])

    respond_to do |format|
      if @medical_report.update_attributes(params[:medical_report])
        flash[:notice] = 'MedicalReport was successfully updated.'
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
    @medical_report = MedicalReport.find(params[:id])
    @medical_report.destroy

    respond_to do |format|
      format.html { redirect_to(medical_reports_url) }
      format.xml  { head :ok }
    end
  end
end
