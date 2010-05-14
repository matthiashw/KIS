class CreateCatalogs < ActiveRecord::Migration
  def self.up
    create_table :catalogs do |t|
      t.string :year
      t.string :language
      t.integer :catalog_type_id
      t.integer :root_node_id

      t.timestamps
    end
  end

  def self.down
    drop_table :catalogs
  end
end
