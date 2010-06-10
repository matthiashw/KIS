class Comment < ActiveRecord::Base
  belongs_to :patient

  validates_presence_of :comment
end
