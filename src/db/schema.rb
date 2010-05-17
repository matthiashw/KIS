# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100514160746) do

  create_table "appointments", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name"
    t.text     "description"
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cases", :force => true do |t|
    t.date     "entry_date"
    t.date     "leave_date"
    t.integer  "patient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "catalog_types", :force => true do |t|
    t.string   "name"
    t.integer  "active_catalog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "catalogs", :force => true do |t|
    t.string   "year"
    t.string   "language"
    t.integer  "catalog_type_id"
    t.integer  "root_node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.date     "date"
    t.integer  "patient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diagnoses", :force => true do |t|
    t.string   "description"
    t.integer  "icd_entry_id"
    t.integer  "user_id"
    t.integer  "case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.string   "result_name"
    t.boolean  "is_role"
    t.boolean  "is_userdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "field_definitions", :force => true do |t|
    t.integer  "input_type"
    t.integer  "field_entry_id"
    t.integer  "example_ucum_id"
    t.boolean  "is_active"
    t.string   "additional_type_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", :force => true do |t|
    t.text     "comment"
    t.integer  "measured_value_id"
    t.integer  "template_id"
    t.integer  "field_definition_id"
    t.integer  "task_id"
    t.integer  "ucum_entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measured_values", :force => true do |t|
    t.string   "value"
    t.string   "comment"
    t.integer  "field_id"
    t.integer  "task_id"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medications", :force => true do |t|
    t.text     "description"
    t.integer  "atc_entry_id"
    t.integer  "treatment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", :force => true do |t|
    t.string   "first_name"
    t.string   "family_name"
    t.date     "birthdate"
    t.text     "address"
    t.string   "sex"
    t.string   "phone"
    t.integer  "active_case_id"
    t.integer  "extern_medication_treatment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.date     "deadline"
    t.text     "creator_comment"
    t.text     "executor_comment"
    t.integer  "state"
    t.integer  "case_id"
    t.integer  "domain_id"
    t.integer  "creator_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.boolean  "is_active"
    t.integer  "domain_id"
    t.integer  "catalog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates_field_definitions", :id => false, :force => true do |t|
    t.integer "template_id"
    t.integer "field_definition_id"
  end

  create_table "treatments", :force => true do |t|
    t.text     "description"
    t.date     "start_date"
    t.integer  "case_id"
    t.integer  "user_id"
    t.integer  "ops_entry_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "treatments_diagnoses", :id => false, :force => true do |t|
    t.integer "treatment_id"
    t.integer "diagnosis_id"
  end

  create_table "uploaded_files", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.text     "description"
    t.integer  "size"
    t.string   "mime_type"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login_name"
    t.string   "password"
    t.string   "first_name"
    t.string   "family_name"
    t.string   "language"
    t.text     "address"
    t.string   "email"
    t.string   "phone"
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_permissions", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "permission_id"
  end

end
