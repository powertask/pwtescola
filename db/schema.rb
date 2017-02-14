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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170214104421) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "customer_id"
    t.string   "amount_unit"
    t.string   "amount_client"
    t.string   "status"
    t.string   "customer_ticket_quantity"
    t.string   "unit_ticket_quantity"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["customer_id"], name: "index_contracts_on_customer_id", using: :btree
    t.index ["unit_id"], name: "index_contracts_on_unit_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "unit_id"
    t.string   "full_name"
    t.string   "name"
    t.string   "cnpj"
    t.string   "cpf"
    t.string   "zipcode"
    t.string   "city_name"
    t.string   "state"
    t.string   "address"
    t.integer  "address_number"
    t.string   "address_complement"
    t.string   "neighborhood"
    t.string   "email"
    t.string   "phone_local_code"
    t.string   "phone_number"
    t.string   "mobile_local_code"
    t.string   "mobile_number"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["unit_id"], name: "index_customers_on_unit_id", using: :btree
  end

  create_table "debtors", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "customer_id"
    t.string   "name"
    t.string   "cnpj"
    t.string   "cpf"
    t.string   "zipcode"
    t.string   "city_name"
    t.string   "state"
    t.string   "address"
    t.integer  "address_number"
    t.string   "address_complement"
    t.string   "neighborhood"
    t.string   "email"
    t.string   "phone_local_code"
    t.string   "phone_number"
    t.string   "mobile_local_code"
    t.string   "mobile_number"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "origin_code"
    t.index ["customer_id"], name: "index_debtors_on_customer_id", using: :btree
    t.index ["unit_id"], name: "index_debtors_on_unit_id", using: :btree
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "customer_id"
    t.string   "description"
    t.string   "history_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["customer_id"], name: "index_histories_on_customer_id", using: :btree
    t.index ["unit_id"], name: "index_histories_on_unit_id", using: :btree
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "debtor_id"
    t.string   "description"
    t.string   "amount"
    t.string   "document_number"
    t.string   "due_at"
    t.string   "charge"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "contract_id"
    t.integer  "status"
    t.string   "origin_code"
    t.index ["contract_id"], name: "index_tickets_on_contract_id", using: :btree
    t.index ["debtor_id"], name: "index_tickets_on_debtor_id", using: :btree
    t.index ["unit_id"], name: "index_tickets_on_unit_id", using: :btree
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "cnpj_cpf"
    t.string   "zipcode"
    t.string   "state"
    t.string   "city_name"
    t.string   "address"
    t.string   "address_complement"
    t.integer  "address_number"
    t.string   "neighborhood"
    t.string   "email"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "profile"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "unit_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unit_id"], name: "index_users_on_unit_id", using: :btree
  end

  add_foreign_key "contracts", "customers"
  add_foreign_key "contracts", "units"
  add_foreign_key "customers", "units"
  add_foreign_key "debtors", "customers"
  add_foreign_key "debtors", "units"
  add_foreign_key "histories", "customers"
  add_foreign_key "histories", "units"
  add_foreign_key "tickets", "contracts"
  add_foreign_key "tickets", "debtors"
  add_foreign_key "tickets", "units"
  add_foreign_key "users", "units"
end
