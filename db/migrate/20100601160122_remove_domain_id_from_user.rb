class RemoveDomainIdFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :domain_id
  end

  def self.down
    add_column :users, :domain_id, :integer
  end
end
