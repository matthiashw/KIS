
require 'csv'

class CatalogsController < ApplicationController
  # GET /catalogs
  # GET /catalogs.xml
  def index
    @catalogs = Catalog.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @catalogs }
    end
  end

  # GET /catalogs/1
  # GET /catalogs/1.xml
  def show
    @catalog = Catalog.find(params[:id])

    if params.has_key?(:node)
     nodeid=params[:node]
     if nodeid=="0"
        @shownode=@catalog.root_node
     else
       node=Node.find nodeid
        @shownode=node
     end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :partial => 'tree.xml.builder'}
      format.json { render :partial => 'tree.js.erb' ,
        :locals => { :checkbox => params.has_key?('checkbox')?params['checkbox']:'false' } }
    end

  end

  # GET /catalogs/new
  # GET /catalogs/new.xml
  def new
    @catalog = Catalog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @catalog }
    end
  end

  # GET /catalogs/1/edit
  def edit
    @catalog = Catalog.find(params[:id])
  end

  # POST /catalogs
  # POST /catalogs.xml
  def create
    file = params[:catalog][:dump]
    params[:catalog].delete(:dump)
    @catalog = Catalog.new( params[:catalog])
    if file
       importer=ImporterManager.instance.import_methods[@catalog.catalog_type.import_method]
        begin
          importer.import @catalog,file
        rescue
          @catalog.errors.add_to_base t("admin.catalog.errors.import_file_invalid")
        end
        
    else
       @catalog.errors.add_to_base t("admin.catalog.errors.import_file_not_blank")
    end
     
    respond_to do |format|
      if @catalog.errors.empty?
        flash[:notice] = 'Catalog was successfully created.'
        format.html { redirect_to(@catalog) }
        format.xml  { render :xml => @catalog, :status => :created, :location => @catalog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @catalog.errors, :status => :unprocessable_entity }
      end

     
    end
  end

  # PUT /catalogs/1
  # PUT /catalogs/1.xml
  def update
    @catalog = Catalog.find(params[:id])

    respond_to do |format|
      if @catalog.update_attributes(params[:catalog])
        flash[:notice] = 'Catalog was successfully updated.'
        format.html { redirect_to(@catalog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @catalog.errors, :status => :unprocessable_entity }
      end
    end
  end


 


  # DELETE /catalogs/1
  # DELETE /catalogs/1.xml
  def destroy
    @catalog = Catalog.find(params[:id])
    @catalog.destroy

    respond_to do |format|
      format.html { redirect_to(catalogs_url) }
      format.xml  { head :ok }
    end
  end
end
