class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

  def setup
    @domains = Domain.all :conditions => { :is_role => 1 }
    
    if !params.has_key?(:user)
      @user = User.new
    else
      @user = User.new(params[:user])
      @user.attributes = {'domain_ids' => []}.merge(params[:user] || {})

      if @user.save
        update_admin(@user)
        flash.now[:notice] = t('user.messages.registration_success')
        render :action => 'show'
      else
        render :action => 'setup'
      end
    end
    
    
  end

  def update_admin(user)
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=0";
    sql.begin_db_transaction
    sql.update "UPDATE users SET id=1 WHERE username='#{user.username}'";
    sql.commit_db_transaction
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
    return access_denied unless (authorize?(permissions = ["view_user"]) || (authorize?(permissions = ["view_own_user"]) && @user.id == current_user.id))
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def new
    @user = User.new
    @domains = Domain.all :conditions => { :is_role => 1 }
  end
  
  def create
    return false unless authorize(permissions = ["create_user"])
    @user = User.new(params[:user])
    @user.attributes = {'domain_ids' => []}.merge(params[:user] || {})

    if @user.save
      flash.now[:notice] = t('user.messages.registration_success')
      render :action => 'show'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    return access_denied unless (authorize?(permissions = ["edit_user"]) || (authorize?(permissions = ["edit_own_user"]) && @user.id == current_user.id))
    @domains = Domain.all :conditions => { :is_role => 1 }
  end
  
  def update
    @user = User.find(params[:id])
    return access_denied unless (authorize?(permissions = ["edit_user"]) || (authorize?(permissions = ["edit_own_user"]) && @user.id == current_user.id))
    @user.attributes = {'domain_ids' => []}.merge(params[:user] || {})
    if @user.update_attributes(params[:user])

      if (current_user.id == @user.id)
        I18n.locale = @user.language
      end

      flash.now[:notice] = t('user.messages.update_success')
      render :action => 'show'
    else
      render :action => 'edit'
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    return false unless authorize(permissions = ["delete_user"])
    if params[:id] == 1
      flash.now[:error] = t('user.messages.destroy_error')
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
