class CreateFieldDefinitions < ActiveRecord::Migration
  def self.up
    create_table :field_definitions do |t|
      t.integer :input_type
      t.integer :field_entry_id
      t.integer :example_ucum_id
      t.boolean :is_active
      t.string :additional_type_info

      t.timestamps
    end
    create_table :templates_field_definitions, :id => false do |t|
      t.integer :template_id
      t.integer :field_definition_id
    end
  end

  def self.down
    drop_table :field_definitions
    drop_table :templates_field_definitions
  end
end
