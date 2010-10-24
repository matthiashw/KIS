class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :code
      t.string :name
      t.text :description
      t.integer :node_id

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
