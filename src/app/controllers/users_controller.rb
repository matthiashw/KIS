class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

  # GET /patients
  # GET /patients.xml
  def index
    return access_denied unless authorize(permissions = ["view_user"])
    
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

    if !current_user
      render :layout => 'frontpage'
    end
  end
  
  def create
    @user = User.new(params[:user])
    @user.attributes = {'domain_ids' => []}.merge(params[:user] || {})
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.attributes = {'domain_ids' => []}.merge(params[:user] || {})
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

end
