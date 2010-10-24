class CreateDomainMemberships < ActiveRecord::Migration
  
  def self.up
    create_table :domain_memberships do |t|
      t.integer :roleable_id
      t.string :roleable_type
      t.integer :domain_id

      t.timestamps
    end
  end

  def self.down
    drop_table :domain_memberships
  end

end
