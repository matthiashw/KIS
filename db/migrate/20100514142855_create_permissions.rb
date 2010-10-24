class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    create_table :users_permissions, :id => false do |t|
      t.integer :user_id
      t.integer :permission_id
    end
  end

  def self.down
    drop_table :permissions
    drop_table :users_permissions
  end
end
