class MedicalTemplatesController < ApplicationController
  def edit
     @medical_template = MedicalTemplate.find(params[:id])
  end

  def new
    @medical_template = MedicalTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @medical_template }
    end
  end

  def index
     @medical_templates = MedicalTemplate.all

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @medical_templates }
    end
  end

  def show
     @medical_template = MedicalTemplate.find(params[:id])

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @medical_template }
    end
  end

def create
    @medical_template = MedicalTemplate.new(params[:medical_template])

    respond_to do |format|
      if @medical_template.save
        flash[:notice] = 'Template was successfully created.'
        format.html { redirect_to(@medical_template) }
        format.xml  { render :xml => @medical_template, :status => :created, :location => @medical_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @medical_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def update
    @medical_template = MedicalTemplate.find(params[:id])

    respond_to do |format|
      if @medical_template.update_attributes(params[:medical_template])
        flash[:notice] = 'Template was successfully updated.'
        format.html { redirect_to(@medical_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @medical_template.errors, :status => :unprocessable_entity }
      end
    end
  end

 
  def destroy
    @medical_template = MedicalTemplate.find(params[:id])
    @medical_template.destroy

    respond_to do |format|
      format.html { redirect_to(medical_templates_url) }
      format.xml  { head :ok }
    end
  end
end
