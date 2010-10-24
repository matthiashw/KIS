class CreateMeasuredValues < ActiveRecord::Migration
  def self.up
    create_table :measured_values do |t|
      t.string :value
      t.string :comment
      t.integer :field_id
      t.integer :task_id
      t.integer :template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :measured_values
  end
end
