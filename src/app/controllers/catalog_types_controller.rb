class CatalogTypesController < ApplicationController

  # GET /catalog_types
  # GET /catalog_types.xml
  def index
    @catalog_types = CatalogType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @catalog_types }
    end
  end

  # GET /catalog_types/1
  # GET /catalog_types/1.xml
  def show
    @catalog_type = CatalogType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @catalog_type }
    end
  end

  # GET /catalog_types/new
  # GET /catalog_types/new.xml
  def new
    @catalog_type = CatalogType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @catalog_type }
    end
  end

  # GET /catalog_types/1/edit
  def edit
    @catalog_type = CatalogType.find(params[:id])
  end

  # POST /catalog_types
  # POST /catalog_types.xml
  def create
    @catalog_type = CatalogType.new(params[:catalog_type])

    respond_to do |format|
      if @catalog_type.save
        flash.now[:notice] = t('admin.catalog_type.flash.created')
        format.html { redirect_to(@catalog_type) }
        format.xml  { render :xml => @catalog_type, :status => :created, :location => @catalog_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @catalog_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /catalog_types/1
  # PUT /catalog_types/1.xml
  def update
    @catalog_type = CatalogType.find(params[:id])

    respond_to do |format|
      if @catalog_type.update_attributes(params[:catalog_type])
        flash.now[:notice] = t('admin.catalog_type.flash.updated')
        format.html { redirect_to(@catalog_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @catalog_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /catalog_types/1
  # DELETE /catalog_types/1.xml
  def destroy
    @catalog_type = CatalogType.find(params[:id])
    @catalog_type.destroy

    respond_to do |format|
      format.html { redirect_to(catalog_types_url) }
      format.xml  { head :ok }
    end
  end
end
