class Node < ActiveRecord::Base
  validates_presence_of :name
  acts_as_tree :order => 'name'
  has_many :entries , :dependent => :destroy ,:order => 'code'
  has_one :catalog , :foreign_key => "root_node_id"
end
