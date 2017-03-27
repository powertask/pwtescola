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

ActiveRecord::Schema.define(version: 20170327161845) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.integer  "unit_id"
    t.string   "name"
    t.string   "bank_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_bank_accounts_on_unit_id", using: :btree
  end

  create_table "bank_slips", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "customer_id"
    t.integer  "debtor_id"
    t.integer  "bank_account_id"
    t.integer  "contract_id"
    t.integer  "origin_code"
    t.string   "our_number"
    t.decimal  "amount_principal"
    t.date     "due_at"
    t.string   "customer_name"
    t.string   "customer_document"
    t.date     "paid_at"
    t.decimal  "paid_amount_principal"
    t.string   "shorten_url"
    t.integer  "status"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["bank_account_id"], name: "index_bank_slips_on_bank_account_id", using: :btree
    t.index ["contract_id"], name: "index_bank_slips_on_contract_id", using: :btree
    t.index ["customer_id"], name: "index_bank_slips_on_customer_id", using: :btree
    t.index ["debtor_id"], name: "index_bank_slips_on_debtor_id", using: :btree
    t.index ["unit_id"], name: "index_bank_slips_on_unit_id", using: :btree
  end

  create_table "contract_tickets", force: :cascade do |t|
    t.integer "unit_id"
    t.integer "contract_id"
    t.integer "ticket_id"
    t.decimal "amount_principal"
    t.decimal "amount_monetary_correction"
    t.decimal "amount_interest"
    t.decimal "amount_fine"
    t.decimal "amount_tax"
    t.index ["contract_id"], name: "index_contract_tickets_on_contract_id", using: :btree
    t.index ["ticket_id"], name: "index_contract_tickets_on_ticket_id", using: :btree
    t.index ["unit_id"], name: "index_contract_tickets_on_unit_id", using: :btree
  end

  create_table "contracts", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "customer_id"
    t.integer  "debtor_id"
    t.decimal  "amount_principal"
    t.decimal  "amount_monetary_correction"
    t.decimal  "amount_interest"
    t.decimal  "amount_fine"
    t.integer  "status"
    t.integer  "ticket_quantity"
    t.string   "origin_code"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.index ["customer_id"], name: "index_contracts_on_customer_id", using: :btree
    t.index ["debtor_id"], name: "index_contracts_on_debtor_id", using: :btree
    t.index ["unit_id"], name: "index_contracts_on_unit_id", using: :btree
    t.index ["user_id"], name: "index_contracts_on_user_id", using: :btree
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
    t.string   "origin_code"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "fl_charge_monetary_correction"
    t.boolean  "fl_charge_interest"
    t.boolean  "fl_charge_fine"
    t.boolean  "fl_charge_tax"
    t.integer  "bank_account_id"
    t.index ["bank_account_id"], name: "index_customers_on_bank_account_id", using: :btree
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
    t.string   "origin_code"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["customer_id"], name: "index_debtors_on_customer_id", using: :btree
    t.index ["unit_id"], name: "index_debtors_on_unit_id", using: :btree
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "customer_id"
    t.integer  "debtor_id"
    t.integer  "user_id"
    t.string   "description"
    t.datetime "history_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["customer_id"], name: "index_histories_on_customer_id", using: :btree
    t.index ["debtor_id"], name: "index_histories_on_debtor_id", using: :btree
    t.index ["unit_id"], name: "index_histories_on_unit_id", using: :btree
    t.index ["user_id"], name: "index_histories_on_user_id", using: :btree
  end

  create_table "monetary_indices", force: :cascade do |t|
    t.date    "index_at"
    t.decimal "value",    precision: 5, scale: 4
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "debtor_id"
    t.integer  "customer_id"
    t.integer  "contract_id"
    t.string   "description"
    t.decimal  "amount_principal"
    t.string   "document_number"
    t.date     "due_at"
    t.boolean  "charge"
    t.string   "origin_code"
    t.integer  "sequence"
    t.integer  "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["contract_id"], name: "index_tickets_on_contract_id", using: :btree
    t.index ["customer_id"], name: "index_tickets_on_customer_id", using: :btree
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
    t.string   "origin_code"
    t.integer  "unit_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unit_id"], name: "index_users_on_unit_id", using: :btree
  end

  add_foreign_key "bank_accounts", "units"
  add_foreign_key "bank_slips", "bank_accounts"
  add_foreign_key "bank_slips", "contracts"
  add_foreign_key "bank_slips", "customers"
  add_foreign_key "bank_slips", "debtors"
  add_foreign_key "bank_slips", "units"
  add_foreign_key "contract_tickets", "contracts"
  add_foreign_key "contract_tickets", "tickets"
  add_foreign_key "contract_tickets", "units"
  add_foreign_key "contracts", "customers"
  add_foreign_key "contracts", "debtors"
  add_foreign_key "contracts", "units"
  add_foreign_key "contracts", "users"
  add_foreign_key "customers", "bank_accounts"
  add_foreign_key "customers", "units"
  add_foreign_key "debtors", "customers"
  add_foreign_key "debtors", "units"
  add_foreign_key "histories", "customers"
  add_foreign_key "histories", "debtors"
  add_foreign_key "histories", "units"
  add_foreign_key "histories", "users"
  add_foreign_key "tickets", "contracts"
  add_foreign_key "tickets", "customers"
  add_foreign_key "tickets", "debtors"
  add_foreign_key "tickets", "units"
  add_foreign_key "users", "units"
end
