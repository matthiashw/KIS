class CatalogIdToEntryShortcut < ActiveRecord::Migration
  def self.up
    add_column :entries, :catalog_id, :int
    Entry.all.each { |entry|
    begin
      entry.catalog_id=entry.node.root.catalog.id
       entry.save
    rescue

    end
    }
  end

  def self.down
    remove_column :entries, :catalog_id
  end
end
