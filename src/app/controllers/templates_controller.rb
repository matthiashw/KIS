class TemplatesController < ApplicationController
  def edit
     @temp = Template.find(params[:id])
  end

  def new
    @temp = Template.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @template }
    end
  end

  def index
     @templates = Template.all

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @templates }
    end
  end

  def show
     @temp = Template.find(params[:id])

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @template }
    end
  end

def create
    @temp = Template.new(params[:template])

    respond_to do |format|
      if @temp.save
        flash[:notice] = 'Template was successfully created.'
        format.html { redirect_to(@temp) }
        format.xml  { render :xml => @temp, :status => :created, :location => @temp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @temp.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def update
    @temp = Template.find(params[:id])

    respond_to do |format|
      if @temp.update_attributes(params[:template])
        flash[:notice] = 'Template was successfully updated.'
        format.html { redirect_to(@temp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @temp.errors, :status => :unprocessable_entity }
      end
    end
  end

 
  def destroy
    @temp = Template.find(params[:id])
    @temp.destroy

    respond_to do |format|
      format.html { redirect_to(templates_url) }
      format.xml  { head :ok }
    end
  end
end
