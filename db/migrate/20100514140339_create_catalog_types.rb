class CreateCatalogTypes < ActiveRecord::Migration
  def self.up
    create_table :catalog_types do |t|
      t.string :name
      t.integer :active_catalog_id
      t.timestamps
    end
  end

  def self.down
    drop_table :catalog_types
  end
end
