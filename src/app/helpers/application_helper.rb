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

end
