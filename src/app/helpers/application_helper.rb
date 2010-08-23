# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
include FormStyleHelper

  def current_controller_help
    return @current_controller_help if defined?(@current_controller_help)

    @current_controller_help = "help." + request.path_parameters['controller'] + "." + request.path_parameters['action'] + ".text"
  end

  def current_controller_help_title
    return @current_controller_help_title if defined?(@current_controller_help_title)

    @current_controller_help_title = "help." + request.path_parameters['controller'] + "." + request.path_parameters['action'] + ".title"
  end
  
  def facebox_link(name, url, cssclass = "facebox-link", onclick)
    link_to(name, url, :rel => "facebox", :class => cssclass, :onclick => onclick)
  end

  def get_locale
    if params[:locale].nil?
      I18n.default_locale
    end
    params[:locale]
  end

  def homepages(user_id)
    h = { t("user.homepage.patient_index")      => patients_path,
          t("user.homepage.task_index")         => tasks_path,
          t("user.homepage.appointment_index")  => appointments_path,
          t("user.homepage.administration")     => admin_index_path }

    unless user_id.nil?
      user = User.find_by_id(user_id)

      if user.has_permission?("view_own_task")
        mytasks = { t("user.homepage.task_mytasks") => mytasks_path(:user_id => user_id)}
        h.merge!(mytasks)
      end

      if user.has_permission?("view_domain_task")
        domaintasks = { t("user.homepage.task_domaintasks") => domaintasks_path(:user_id => user_id)}
        h.merge!(domaintasks)
      end

    end

    h
  end

end
