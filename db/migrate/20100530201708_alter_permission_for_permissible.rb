class AlterPermissionForPermissible < ActiveRecord::Migration
  def self.up
    rename_column :permissions, :name, :action

    add_column :permissions, :permissible_id, :integer
    add_column :permissions, :permissible_type, :string
    add_column :permissions, :granted, :boolean
  end

  def self.down
    rename_column :permissions, :action, :name

    remove_column :permissions, :permissible_id
    remove_column :permissions, :permissible_type
    remove_column :permissions, :granted
  end
end
