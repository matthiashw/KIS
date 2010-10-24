class DomainsController < ApplicationController
  # GET /domains
  # GET /domains.xml
  def index
    return false unless authorize(permissions = ["view_domain"])
    @domains = Domain.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @domains }
    end
  end

  # GET /domains/1
  # GET /domains/1.xml
  def show
    return false unless authorize(permissions = ["view_domain"])
    @domain = Domain.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @domain }
    end
  end

  # GET /domains/new
  # GET /domains/new.xml
  def new
    return false unless authorize(permissions = ["create_domain"])
    @domain = Domain.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @domain }
    end
  end

  # GET /domains/1/edit
  def edit
    return false unless authorize(permissions = ["edit_domain"])
    @domain = Domain.find(params[:id])
  end

  # POST /domains
  # POST /domains.xml
  def create
    return false unless authorize(permissions = ["create_domain"])
    @domain = Domain.new(params[:domain])

    respond_to do |format|
      if @domain.save
        flash.now[:notice] = t('domain.messages.create_success')
        format.html { redirect_to(@domain) }
        format.xml  { render :xml => @domain, :status => :created, :location => @domain }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /domains/1
  # PUT /domains/1.xml
  def update
    return false unless authorize(permissions = ["edit_domain"])
    @domain = Domain.find(params[:id])

    respond_to do |format|
      if @domain.update_attributes(params[:domain])
        flash.now[:notice] = t('domain.messages.update_success')
        format.html { redirect_to(@domain) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.xml
  def destroy
    return false unless authorize(permissions = ["delete_domain"])
    if params[:id] == "1"
      flash[:error] = t('domain.messages.destroy_error')
      redirect_to(domains_url) and return false
    end
    @domain = Domain.find(params[:id])
    @domain.destroy

    respond_to do |format|
      format.html { redirect_to(domains_url) }
      format.xml  { head :ok }
    end
  end
end
