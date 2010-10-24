class CreateReportHeaders < ActiveRecord::Migration
  def self.up
    create_table :report_headers do |t|
      t.text :html
      t.text :title

      t.timestamps
    end
  end

  def self.down
    drop_table :report_headers
  end
end
