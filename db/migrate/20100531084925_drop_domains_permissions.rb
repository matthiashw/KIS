class DropDomainsPermissions < ActiveRecord::Migration
  def self.up
    drop_table :domains_permissions
  end

  def self.down
    create_table :domains_permissions, :id => false do |t|
      t.integer :domain_id
      t.integer :permission_id
    end
  end
end
