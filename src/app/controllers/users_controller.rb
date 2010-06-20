class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

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
      flash[:notice] = "Registration successful."
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
      flash[:notice] = "Successfully updated profile."
      render :action => 'show'
    else
      render :action => 'edit'
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    if params[:id] == 1
      flash[:error] = "The User with the ID 1 can not be deleted!"
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
