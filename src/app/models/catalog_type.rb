class CatalogType < ActiveRecord::Base
  belongs_to :active_catalog , :class_name => "Catalog" , :foreign_key => "active_catalog_id"
  has_many :catalogs

  validates_presence_of :name, :import_method
end
