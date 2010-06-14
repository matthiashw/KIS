class AddCatalogApplications < ActiveRecord::Migration
   def self.up
    add_column :catalog_types , :application, :string
  end

  def self.down
    remove_column :catalog_types, :application
  end
end
