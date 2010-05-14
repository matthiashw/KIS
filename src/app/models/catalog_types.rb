class CatalogTypes < ActiveRecord::Base
  belongs_to :active_catalog , :class_name => "Catalog" , :foreign_key => "active_catalog_id"
  has_many :catalogs
end
