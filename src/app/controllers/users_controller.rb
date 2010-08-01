class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

  def setup
    adminuser = User.find_by_id(1)

    if adminuser == nil
      flash[:message] = t('messages.application.no_admin')
      return false
    end

    return true
  end

  # GET /patients
  # GET /patients.xml
  def index
    return false unless authorize(permissions = ["view_user"])
    render :layout => 'login' unless current_user
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /patients/1
  # GET /patients/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def new
    @user = User.new

    render :layout => 'login' unless current_user
  end
  
  def create
    @user = User.new(params[:user])
    @user.attributes = {'domain_ids' => []}.merge(params[:user] || {})

    if @user.save
      flash[:notice] = t('messages.users.registration_success')
      render :action => 'show'
    else
      if !current_user
        render :layout => 'login', :action => 'new' unless current_user
      else
        render :action => 'new'
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
    render :layout => 'login' unless current_user
  end
  
  def update
    render :layout => 'login' unless current_user
    @user = User.find(params[:id])
    @user.attributes = {'domain_ids' => []}.merge(params[:user] || {})
    if @user.update_attributes(params[:user])
      flash[:notice] = t('messages.users.update_success')
      render :action => 'show'
    else
      render :action => 'edit'
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    if params[:id] == 1
      flash[:error] = t('messages.users.destroy_error')
      redirect_to(users_url) and return false
    end

    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

end
