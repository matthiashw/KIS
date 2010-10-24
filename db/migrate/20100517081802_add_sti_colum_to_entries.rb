class AddStiColumToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :type , :string
  end

  def self.down
    remove_column :entries, :type
  end
end
