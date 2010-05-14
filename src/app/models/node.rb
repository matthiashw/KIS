class Node < ActiveRecord::Base
  acts_as_tree :order => 'created_at'
  has_many :entries
end
