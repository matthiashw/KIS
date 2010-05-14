class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.text :comment
      t.integer :measured_value_id
      t.integer :template_id
      t.integer :field_definition_id
      t.integer :task_id
      t.integer :ucum_entry_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fields
  end
end
