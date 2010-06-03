# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
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

  def make_image_link(linktext, cssclass = '')
    content_tag(:span, linktext, :class => "#{cssclass}")
  end

  def is_active?(controller_name, action_name = "")
    if action_name != ""
      return "active" if params[:action] == action_name && params[:controller] == controller_name
    else
      return "active" if params[:controller] == controller_name
    end
  end

  def make_submenu?(*args)
    args.each do |a|
      return true if params[:controller] == a
    end
    return false
  end

end
