class CatalogType < ActiveRecord::Base
  validates_presence_of :name,:import_method,:application
  validates_uniqueness_of :application , :if => Proc.new { |type| type.application!="template" }
  validate do |type|
    apclass=CatalogManager.instance.applications[type.application]['entry_classname']
    if !ImporterManager.instance.entry_types[type.import_method].constantize.new.is_a?(apclass.constantize)
        type.errors.add_to_base I18n.t('admin.catalog_type.errors.application')
    end
  end

  belongs_to :active_catalog , :class_name => "Catalog" , :foreign_key => "active_catalog_id"
  has_many :catalogs, :dependent => :destroy
end
