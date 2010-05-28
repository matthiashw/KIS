class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :name
      t.string :result_name
      t.boolean :is_role
      t.boolean :is_userdomain

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
