# These helper methods can be called in your template to set variables to be used in the layout
module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  # returns a span tag with given text an optional class.
  # this is for making an image background inside a link in the main navigation
  def make_image_link(linktext, cssclass = '')
    content_tag(:span, linktext, :class => "#{cssclass}")
  end

  # renders the body  id depending on the current controller
  def make_body_id
    id = ""
    id = "page-#{params[:controller]}" if params.has_key?('controller')

    id
  end

  # renders the body  id depending on the current action
  def make_body_classes
    classes = ""
    classes += "#{params[:action]}-action" if params.has_key?('action')

    classes
  end

  # returns active if the given controller (and action)
  # is the current controller (and action)
  def is_active?(controller_name, action_name = "")
    activeclass = ""
    if action_name != ""
      activeclass = "active" if params[:action] == action_name && params[:controller] == controller_name
    else
      activeclass = "active" if params[:controller] == controller_name
    end

    if controller_name == "patienttasks"
      if action_name != ""
        activeclass = "active" if params[:action] == action_name && params[:controller] == "tasks" && params[:patient_id]
      else
        activeclass = "active" if params[:controller] == "tasks" && params[:patient_id]
      end
    end

    if controller_name == "usertasks"
      if action_name != ""
        activeclass = "active" if params[:action] == action_name && params[:controller] == "tasks" && params[:user_id]
      else
        activeclass = "active" if params[:controller] == "tasks" && params[:user_id]
      end
    end

    if activeclass == ""
      activeclass = "inactive"
    end

    activeclass
  end

  # returns active if the current controller
  # is one of the given controllers
  def is_active_multiple_controller?(*args)
    activeclass = ""

    args.each do |a|
      activeclass = "active" if params[:controller] == a

      if is_patienttask(a) != ""
        activeclass = is_patienttask(a)
      end
      if is_usertask(a) != ""
        activeclass = is_usertask(a)
      end

    end
    
    if activeclass == ""
      activeclass = "inactive"
    end

    activeclass
  end

  # returns true if the current controller
  # is one of the given controllers
  def is_controller_active?(*args)
    args.each do |a|
      return true if params[:controller] == a

      return true if is_usertask_active?(a)
      return true if is_patienttask_active?(a)
    end
    return false
  end

  def is_patienttask(task)
    cssclass = ""
    if task == "patienttasks"
      if params[:controller] == "tasks" && params[:patient_id]
        cssclass = "active"
      end
    end

    cssclass
  end

  def is_usertask(task)
    cssclass = ""
    if task == "usertasks"
      if params[:controller] == "tasks" && params[:user_id]
        cssclass = "active"
      end
    end

    cssclass
  end

  def is_patienttask_active?(task)
    if task == "patienttasks"
      if params[:controller] == "tasks" && params[:patient_id]
        return true
      end
    end

    return false
  end

  def is_usertask_active?(task)
    if task == "usertasks"
      if params[:controller] == "tasks" && params[:user_id]
        return true
      end
    end

    return false
  end

  # formats datetime
  def show_datetime(datetime)
    if !datetime.nil?
      datetime.strftime("%d. %B %Y - %H:%M")
    end
  end

  # formats date
  def show_date(date)
    if !date.nil?
      date.strftime("%d. %B %Y")
    end
  end

end
