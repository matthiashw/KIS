# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale, :login_required
  
  helper :all # include all helpers, all the time
  helper_method :current_active_patient, :current_user, :current_user_session, :authorize?

  protect_from_forgery

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  def set_locale
  # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end

  def default_url_options(options={})
    #logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
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

  # render access denied if user has no permission
  # to view the page
  def access_denied
    flash[:error] = t('messages.application.no_permission')
    render :partial => 'shared/error403', :status => 403, :layout => true and return false
  end

  private
  
  def current_active_patient
    return @current_active_patient if defined?(@current_active_patient)
    
    if session.has_key?(:active_patient_id)
      @current_active_patient = Patient.find(session[:active_patient_id])
    else
      @current_active_patient = nil
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

  def login_required
    #if system_has_admin?
    #  redirect_to new_user_session_path unless current_user
    #else
    #  redirect_to new_user_path unless current_user
    #end

    redirect_to new_user_path unless current_user
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

  # check if the superadmin is present in the system at login
  def system_has_admin?
    adminuser = User.find_by_id(1)

    if adminuser == nil
      flash[:message] = t('messages.application.no_admin')
      return false
    end

    return true
  end

end
