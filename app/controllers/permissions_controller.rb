class PermissionsController < ApplicationController
  require 'yaml'

  before_filter :authorize

  # GET /permissions
  # GET /permissions.xml
  def index
    @permissions = Permission.all

    #read permissions from yaml file
    read_permissions
    
    @domains = Domain.find(:all, :conditions => { :is_role => 1 })

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @permissions }
    end
  end

  def read_permissions
    @perms = YAML.load_file(RAILS_ROOT + "/config/permissions.yml")
  end

  def update_all_permissions
    
    # first delete all existing permissions
    Permission.delete_all()
    
    if params[:perms]
      # now set the permissions
      params[:perms].each do |perm|
        da = perm.split(/;/)
        domainname = da[0]
        action = da[1]
        d = Domain.find(:first, :conditions => "name = '#{domainname}'")
        d.permissions << Permission.new(:action => action, :granted => true) unless d == nil
        flash.now[:notice] = t('permissions.messages.updated')
      end
    end
    
    redirect_to permissions_path
  end

  protected
  def authorize(permissions = ["set_permissions"])
    super(permissions)
  end

end
