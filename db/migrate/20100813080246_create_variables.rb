class CreateVariables < ActiveRecord::Migration
  def self.up
    create_table :variables do |t|
      t.string :name
      t.text :value
      t.timestamps
    end
  end

  def self.down
    drop_table :variables
  end
end
