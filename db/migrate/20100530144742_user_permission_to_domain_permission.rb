class UserPermissionToDomainPermission < ActiveRecord::Migration
  def self.up
     rename_table :users_permissions, :domains_permissions
     rename_column :domains_permissions, :user_id, :domain_id

  end

  def self.down
     rename_column :domains_permissions,  :domain_id,:user_id
      rename_table  :domains_permissions,:users_permissions
  end
end
