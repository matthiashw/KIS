class AlterStartDateEndDateAppointments < ActiveRecord::Migration
  def self.up
    change_column :appointments, :start_date, :datetime
    change_column :appointments, :end_date, :datetime
  end

  def self.down
    change_column :appointments, :start_date, :date
    change_column :appointments, :end_date, :date
  end
end
