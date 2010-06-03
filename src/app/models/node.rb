class Node < ActiveRecord::Base
  acts_as_tree :order => 'name'
  has_many :entries ,:dependent => :destroy
end
