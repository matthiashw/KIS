class Node < ActiveRecord::Base
  validates_presence_of :name
  acts_as_tree :order => 'created_at'
  has_many :entries , :dependent => :destroy
  has_one :catalog , :foreign_key => "root_node_id"
end
