class RemoveDescriptionFromPermissions < ActiveRecord::Migration
  def self.up
    remove_column :permissions, :description
  end

  def self.down
    add_column :permissions, :description, :string
  end
end
