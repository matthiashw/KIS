class CaseToCaseFile < ActiveRecord::Migration
    def self.up
        rename_table :cases, :case_files
        rename_column :treatments, :case_id, :case_file_id
        rename_column :tasks, :case_id, :case_file_id
        rename_column :diagnoses, :case_id, :case_file_id
        rename_column :patients, :active_case_id, :active_case_file_id
    end
    def self.down
        rename_table :case_files, :cases
        rename_column :treatments, :case_file_id ,:case_id
        rename_column :tasks, :case_file_id ,:case_id
        rename_column :diagnoses, :case_file_id ,:case_id
        rename_column :patients, :active_case_file_id ,:active_case_id
    end
end
