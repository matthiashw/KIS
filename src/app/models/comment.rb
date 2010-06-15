class Comment < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 3

  belongs_to :patient

  validates_presence_of :comment
end
