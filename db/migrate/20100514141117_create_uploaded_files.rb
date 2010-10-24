class CreateUploadedFiles < ActiveRecord::Migration
  def self.up
    create_table :uploaded_files do |t|
      t.string :name
      t.string :path
      t.text :description
      t.integer :size
      t.string :mime_type
      t.integer :task_id
      t.timestamps
    end
  end

  def self.down
    drop_table :uploaded_files
  end
end
