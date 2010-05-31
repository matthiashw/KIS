class AddCatalogImportMethod < ActiveRecord::Migration
  def self.up
    add_column :catalog_types , :import_method, :string
  end

  def self.down
    remove_column :catalog_types, :import_method
  end
end
