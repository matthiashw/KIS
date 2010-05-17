class RemoveMeassuredValueId < ActiveRecord::Migration
  def self.up
    remove_column :fields , :measured_value_id
  end

  def self.down
     add_column :fields , :measured_value_id, :integer
  end
end
