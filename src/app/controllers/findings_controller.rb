class FindingsController < ApplicationController
  def index
    return false unless authorize(permissions = ["access_finding"])

    @findings = Task.all :conditions => { :state => Task.state_closed }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @domains }
    end
  end

end
