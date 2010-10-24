class AlterUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :login_name, :username
    rename_column :users, :password, :crypted_password

    add_column :users, :password_salt, :string
    add_column :users, :persistence_token, :string
  end

  def self.down
    rename_column :users, :username, :login_name
    rename_column :users, :crypted_password, :password

    remove_column :users, :password_salt
    remove_column :users, :persistence_token
  end
end
