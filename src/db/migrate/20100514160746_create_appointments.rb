class CreateAppointments < ActiveRecord::Migration
  def self.up
    create_table :appointments do |t|
      t.date :start_date
      t.date :end_date
      t.string :name
      t.text :description
      t.integer :task_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :appointments
  end
end
