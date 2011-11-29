# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111129195737) do

  create_table "apprenticeships", :force => true do |t|
    t.integer  "instructor_id"
    t.integer  "apprentice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.string   "zipcode"
    t.string   "street"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codes", :force => true do |t|
    t.text     "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "codegroup"
  end

  create_table "ihks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_entries", :force => true do |t|
    t.integer  "report_id"
    t.datetime "date"
    t.float    "duration_in_hours"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_entries", ["report_id"], :name => "index_report_entries_on_report_id"

  create_table "reports", :force => true do |t|
    t.date     "period_start"
    t.date     "period_end"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["user_id"], :name => "index_reports_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.boolean  "read",       :default => false
    t.boolean  "commit",     :default => false
    t.boolean  "export",     :default => false
    t.boolean  "check",      :default => false
    t.boolean  "modify",     :default => false
    t.boolean  "admin",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "report_id"
    t.integer  "stype"
    t.datetime "date"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["report_id"], :name => "index_statuses_on_report_id"

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.integer  "job_id"
    t.integer  "ihk_id"
    t.integer  "code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "templates", ["code_id"], :name => "index_templates_on_code_id"
  add_index "templates", ["ihk_id"], :name => "index_templates_on_ihk_id"
  add_index "templates", ["job_id"], :name => "index_templates_on_job_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "forename"
    t.string   "zipcode"
    t.string   "street"
    t.string   "city"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.boolean  "deleted",         :default => false
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.integer  "business_id"
    t.integer  "template_id"
  end

  add_index "users", ["business_id"], :name => "index_users_on_business_id"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"

end
