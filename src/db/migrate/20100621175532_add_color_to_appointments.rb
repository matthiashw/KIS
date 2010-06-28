class AddColorToAppointments < ActiveRecord::Migration
  def self.up
    add_column :appointments, :color, :string, :default => "#008E00"
  end

  def self.down
    remove_column :color
  end
end
