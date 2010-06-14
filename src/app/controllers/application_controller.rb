# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale, :login_required
  def set_locale
  # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  helper_method :current_active_patient, :current_user, :current_user_session, :authorize?

  def default_url_options(options={})
    #logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
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
   unless current_user
     #flash[:error] = 'You must be logged in to view this page.'
     redirect_to new_user_session_path
   end
  end

  protected
  def authorize(permissions = [])
    return true if current_user_is_admin?
    return current_user_permission?(*permissions) || access_denied
  end

  def authorize?(permissions = [])
    return current_user_is_admin? || current_user_permission?(*permissions)
  end

  def access_denied
    flash[:error] = 'You have no permission to view this page.'
    render :file => '/layouts/error.haml', :status => 403, :layout => false and return false
  end

  private
  def current_user_permission?(permissions = [])
    return current_user && current_user.has_permission?(*permissions)
  end

  def current_user_is_admin?
    return current_user && current_user.id == 1
  end

end
