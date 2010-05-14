class Catalog < ActiveRecord::Base
  belongs_to :root_node , :class_name => "Node" , :foreign_key => "root_node_id"
  belongs_to :catalog_type
  has_one :catalog_type
  has_many :templates

end
