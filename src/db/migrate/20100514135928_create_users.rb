class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login_name
      t.string :password
      t.string :first_name
      t.string :family_name
      t.string :language
      t.text :address
      t.string :email
      t.string :phone
      t.integer :domain_id
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
