class MedicalTemplatesController < ApplicationController
  
  def edit
    return false unless authorize(permissions = ["edit_medical_templates"])
    @medical_template = MedicalTemplate.find(params[:id])
  end

  def edit_field_definition
    @medical_template = MedicalTemplate.find(params[:id])
    @field_definition = FieldDefinition.find(params[:field_id])
    @catalog = CatalogManager.instance.catalog('ucum_units')
  end

  def update_field_definition
    @medical_template = MedicalTemplate.find(params[:id])
    @field_definition = FieldDefinition.find(params[:field_id])
    if(params[:example_ucum_unit])
      @field_definition.example_ucum_id=params[:example_ucum_unit]
      @field_definition.save
    end
    respond_to do |format|
      if @field_definition.update_attributes(params[:field_definition])
        flash.now[:notice] = t('medical_template.messages.update_fielddef_success')
        format.html { redirect_to(@medical_template) }
      else
        format.html { render :action => "edit_field_definition" }
      end
    end
  end

  def change_fields
    @medical_template = MedicalTemplate.find(params[:id])
    @catalog_source = Catalog.find(params[:catalog_source])
  end

  def delete_field
    @medical_template = MedicalTemplate.find(params[:id])
    field = FieldDefinition.find (params[:field_id])
    @medical_template.field_definitions.delete(field)
    @medical_template.save

    respond_to do |format|
        format.html { redirect_to(@medical_template) }
    end
  end

  def update_fields
    @medical_template = MedicalTemplate.find(params[:id])
    new_field_ids = params[:new_field_ids]
    
    if new_field_ids != ""
      field_ids = new_field_ids.split(',')
      field_ids.each { |fieldentry|
        entry = FieldEntry.find fieldentry
        if !@medical_template.field_definitions.find_index entry.field_definition
          @medical_template.field_definitions.push entry.field_definition
        end
       }
       @medical_template.save
       flash.now[:notice] = t('medical_template.messages.added_field_success')
    end

    respond_to do |format|
        format.html { redirect_to(@medical_template) }
    end
  end

  def new
    return false unless authorize(permissions = ["create_medical_templates"])
    @medical_template = MedicalTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @medical_template }
    end
  end

  def index
    return false unless authorize(permissions = ["view_medical_templates"])
    @medical_templates = MedicalTemplate.all

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @medical_templates }
    end
  end

  def show
    return false unless authorize(permissions = ["view_medical_templates"])

    @medical_template = MedicalTemplate.find(params[:id])
    template_catalogs = CatalogManager.instance.template_catalogs
    @catalog_sources = Hash.new
    template_catalogs.each { |catalog|
      @catalog_sources[catalog.catalog_select_name]=catalog.id
    }
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @medical_template }
    end
  end

  def create
    return false unless authorize(permissions = ["create_medical_templates"])
    @medical_template = MedicalTemplate.new(params[:medical_template])

    respond_to do |format|
      if @medical_template.save
        flash.now[:notice] = t('medical_template.messages.create_template_success')
        format.html { redirect_to(@medical_template) }
        format.xml  { render :xml => @medical_template, :status => :created, :location => @medical_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @medical_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    return false unless authorize(permissions = ["edit_medical_templates"])
    @medical_template = MedicalTemplate.find(params[:id])

    respond_to do |format|
      if @medical_template.update_attributes(params[:medical_template])
        flash.now[:notice] = t('medical_template.messages.update_template_success')
        format.html { redirect_to(@medical_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @medical_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    return false unless authorize(permissions = ["delete_medical_templates"])
    @medical_template = MedicalTemplate.find(params[:id])
    @medical_template.destroy

    respond_to do |format|
      format.html { redirect_to(medical_templates_url) }
      format.xml  { head :ok }
    end
  end
end
