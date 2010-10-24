################################################################################
# FormStyleHelper
# Adds helpful class names to HTML form elements
################################################################################
# Overrides commonly-used Rails form methods in order to add descriptive
# class names for use in CSS.
#
# This code is released under the terms of the MIT License
#
# Author: Kenn Wilson
# Copyright: Copyright (c) 2008 Kenn Wilson
# Version: 1.1
# URL: http://labs.corvidworks.com/rails/
#
###############################################################################
# The MIT License
#
# Copyright (c) 2008 Kenn Wilson
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the
# following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
# USE OR OTHER DEALINGS IN THE SOFTWARE.
#
###############################################################################
# Usage:
#
# Place this file in your Rails application's helpers directory (app/helpers)
# and include FormStyleHelper in your main ApplicationHelper in order to make
# it available to all views.
#
#     include FormStyleHelper
#
# Use any of the supported form methods as you would normally. In addition
# to their normal behavior, each will now include helpful CSS class names
# for easier styling. The classes assigned by each method are listed above
# each method below.
#
###############################################################################

module FormStyleHelper

	# Methods from FormHelper
	# http://api.rubyonrails.com/classes/ActionView/Helpers/FormHelper.html

	# Class: "check_box"
	def check_box(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
		options = check_options(options)
		options[:class] << 'check_box'
		super(object_name, method, options, checked_value, unchecked_value)
	end

	# Class: "file_field text_field"
	def file_field(object_name, method, options = {})
		options = check_options(options)
		options[:class] << 'file_field'
		super(object_name, method, options)
	end

	# Class: "hidden_field text_field"
	def hidden_field(object_name, method, options = {})
		options = check_options(options)
		options[:class] << 'hidden_field'
		super(object_name, method, options)
	end

	# Class: "password_field text_field"
	def password_field(object_name, method, options = {})
		options = check_options(options)
		options[:class] << 'password_field'
		super(object_name, method, options)
	end

	# Class: "radio"
	def radio_button(object_name, method, tag_value, options = {})
		options = check_options(options)
		options[:class] << 'radio'
		super(object_name, method, tag_value, options)
	end

	# Class: "text_area"
	def text_area(object_name, method, options = {})
		options = check_options(options)
		options[:class] << 'text_area'
		super(object_name, method, options)
	end

	# Class: "text_field"
	def text_field(object_name, method, options = {})
		options = check_options(options)
		options[:class] << 'text_field'
		super(object_name, method, options)
	end


	# Methods from FormTagHelper
	# http://api.rubyonrails.com/classes/ActionView/Helpers/FormTagHelper.html

	# Class: "check_box"
	def check_box_tag(name, value = "1", checked = false, options = {})
		options = check_options(options)
		options[:class] << 'checkbox'
		super(name, value, checked, options)
	end

	# Class: "file_field text_field"
	def file_field_tag(name, options = {})
		options = check_options(options)
		options[:class] << 'file_field'
		super(name, options)
	end

	# Class: "hidden_field text_field"
	def hidden_field_tag(name, value = nil, options = {})
		options = check_options(options)
		options[:class] << 'hidden_field'
		super(name, value, options)
	end

	# Class: "image_submit"
	def image_submit_tag(source, options = {})
		options = check_options(options)
		options[:class] << 'image_submit'
		super(source, options)
	end

	# Class: "password_field text_field"
	def password_field_tag(name = "password", value = nil, options = {})
		options = check_options(options)
		options[:class] << 'password_field'
		super(name, value, options)
	end

	# Class: "radio"
	def radio_button_tag(name, value, checked = false, options = {})
		options = check_options(options)
		options[:class] << 'radio'
		super(name, value, checked, options)
	end

	# Class: "select"
	def select_tag(name, option_tags = nil, options = {})
		options = check_options(options)
		options[:class] << 'select'
		super(name, option_tags, options)
	end

	# Class: "button"
	def submit_tag(value = "Save changes", options = {})
		options = check_options(options)
		options[:class] << 'button'
		super(value, options)
	end

	# Class: "text_area"
	def text_area_tag(name, content = nil, options = {})
		options = check_options(options)
		options[:class] << 'text_area'
		super(name, content, options)
	end

	# Class: "text_field"
	def text_field_tag(name, value = nil, options = {})
		options = check_options(options)
		options[:class] << 'text_field'
		super(name, value, options)
	end


	# Methods from UrlHelper
	# http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html

	# Class: "button"
	def button_to(name, options = {}, html_options = {})
		html_options = check_options(html_options)
		html_options[:class] << 'button'
		super(name, options, html_options)
	end


	# Methods from PrototypeHelper
	# http://api.rubyonrails.org/classes/ActionView/Helpers/PrototypeHelper.html

	# Class: "button"
	def submit_to_remote(name, value, options = {})
		options[:html] ||= Hash.new
		options[:html] = check_options(options[:html])
		options[:html][:class] << 'button'
		super(name, value, options)
	end


	private

	def check_options(options)
		# Make sure :class key exists in hash, append space if it does
		options[:class] ||= String.new
		options[:class] += options[:class].length == 0 ? '' : ' '
		return options
	end

end
