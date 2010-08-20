# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale, :login_required, :check_install, :force_utf8_params
  
  helper :all # include all helpers, all the time
  helper_method :current_active_patient, :current_user, :current_user_session, 
                :authorize?, :get_case_for_view, :get_locale_hash

  protect_from_forgery

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  unless ActionController::Base.consider_all_requests_local
    rescue_from Exception,                           :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::RoutingError,          :with => :render_not_found
    rescue_from ActionController::UnknownController,     :with => :render_not_found
    rescue_from ActionController::UnknownAction,        :with => :render_not_found
  end

  def rootpage
    homepage = current_user.homepage

    if homepage.nil? || homepage.empty?
      redirect_to patients_url
    else
      redirect_to homepage
    end
  end

  def set_locale
  # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end

  def get_locale
    if params[:locale].nil?
      I18n.default_locale
    end
    params[:locale]
  end

  def default_url_options(options={})
    #logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def get_locale_hash
    locations = I18n.available_locales.to_a.map{ |locale| [t('name', :locale => locale), locale] }
    loc_hash = {}
    locations.each do |l|
      loc_hash.merge!({l[0] => l[1].to_s})
    end

    loc_hash
  end

  def models_to_check_for_errors
    ["User"]
  end

  protected

  # returns true or access denied, based on given user permissions
  def authorize(permissions = [])
    return true if current_user_is_admin?
    return current_user_permission?(*permissions) || access_denied
  end

  # returns true or false based on given user permissions
  def authorize?(permissions = [])
    return current_user_is_admin? || current_user_permission?(*permissions)
  end

  # returns true or false, based on given user permissions
  # modified for task with creator id and multiple permissions with logical or
  def task_creator_authorize?(creator_uid, *permissions)
    return true if current_user_is_admin?
    permissions.each do |p|
      if current_user.id == creator_uid && current_user_permission?(p)
        return true
      end
    end
    return false
  end

  # returns true or false, based on given user permissions
  # modified for task with domain id and multiple permissions with logical or
  def task_domain_authorize?(domain_id, *permissions)
    return true if current_user_is_admin?
    permissions.each do |p|
      current_user.domains.each do |d|
        if d.id == domain_id && current_user_permission?(p)
          return true
        end
      end
    end
    return false
  end
  
  # returns true or false, based on given user permissions
  # modified for task with multiple permissions with logical or
  def task_authorize?(*permissions)
    return true if current_user_is_admin?
    permissions.each do |p|
      if current_user_permission?(p)
        return true
      end
    end
    return false
  end

  # returns true or false, based on given user permissions
  # modified for task with creator id and multiple permissions with logical or
  def task_creator_authorize?(creator_uid, *permissions)
    return true if current_user_is_admin?
    permissions.each do |p|
      if current_user.id == creator_uid && current_user_permission?(p)
        return true
      end
    end
    return false
  end

  
  # render access denied if user has no permission
  # to view the page
  def access_denied
    #flash.now[:error] = t('application.messages.no_permission')
    render :partial => 'shared/errors/error403', :status => 403, :layout => true and return false
  end

  private
  
  def current_active_patient
    return @current_active_patient if defined?(@current_active_patient)

    @current_active_patient = nil

    if session.has_key?(:active_patient_id)
      @current_active_patient = Patient.find(session[:active_patient_id]) if !session[:active_patient_id].nil?
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def check_install
    redirect_to install_path unless already_installed?
  end

  def login_required
    redirect_to new_user_session_path unless current_user
  end

  # check if current user has permission to
  # view the page
  def current_user_permission?(permissions = [])
    return current_user && current_user.has_permission?(*permissions)
  end

  # check if the current user is the superadmin
  # of the system (if he has the id 1)
  def current_user_is_admin?
    return current_user && current_user.id == 1
  end

  # get id of active casefile
  # returns casefile wich is active for view
  # if none has been activated it returns active casefile of patient or
  # returns nil if no patient/casefile is active
  def get_case_for_view

    if session.has_key?(:case_view_id)
      return session[:case_view_id]
    else
      if session.has_key?(:active_patient_id)
        activepatient = Patient.find(session[:active_patient_id])
        return activepatient.active_case_file_id
      end
    end
    
    return nil

  end

  def already_installed?
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=0";
    sql.begin_db_transaction
    value =	sql.execute("SELECT value FROM variables WHERE name='install'").fetch_row;
    sql.commit_db_transaction

    if !value.nil?
      value.each do |v|
        if v == "1"
          return true
        end
      end
    end

    return false
  end

  def force_utf8_params
    traverse = lambda do |object, block|
      if object.kind_of?(Hash)
        object.each_value { |o| traverse.call(o, block) }
      elsif object.kind_of?(Array)
        object.each { |o| traverse.call(o, block) }
      else
        block.call(object)
      end
      object
    end
    force_encoding = lambda do |o|
      o.force_encoding(Encoding::UTF_8) if o.respond_to?(:force_encoding)
    end
    traverse.call(params, force_encoding)
  end

  def render_not_found(exception)
    log_error(exception)
    render :partial => "shared/errors/error404", :status => 404, :layout => true
  end

  def render_error(exception)
    log_error(exception)
    render :partial => "shared/errors/error500", :status => 500, :layout => true
  end

end
