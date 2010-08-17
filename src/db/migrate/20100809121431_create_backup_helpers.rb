class CreateBackupHelpers < ActiveRecord::Migration
  def self.up
    create_table :backup_helpers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :backup_helpers
  end
end
