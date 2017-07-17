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

ActiveRecord::Schema.define(version: 20170714014912) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.string "name"
    t.string "bank_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_bank_accounts_on_unit_id"
  end

  create_table "bank_slips", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "customer_id"
    t.integer "debtor_id"
    t.integer "bank_account_id"
    t.integer "contract_id"
    t.integer "contract_ticket_id"
    t.integer "origin_code"
    t.string "our_number"
    t.decimal "amount_principal", default: "0.0"
    t.date "due_at"
    t.string "customer_name"
    t.string "customer_document"
    t.date "paid_at"
    t.decimal "paid_amount_principal", default: "0.0"
    t.string "shorten_url"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_bank_slips_on_bank_account_id"
    t.index ["contract_id"], name: "index_bank_slips_on_contract_id"
    t.index ["contract_ticket_id"], name: "index_bank_slips_on_contract_ticket_id"
    t.index ["customer_id"], name: "index_bank_slips_on_customer_id"
    t.index ["debtor_id"], name: "index_bank_slips_on_debtor_id"
    t.index ["unit_id"], name: "index_bank_slips_on_unit_id"
  end

  create_table "contract_tickets", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "customer_id"
    t.integer "debtor_id"
    t.integer "contract_id"
    t.integer "ticket_id"
    t.decimal "amount_principal", default: "0.0"
    t.decimal "amount_monetary_correction", default: "0.0"
    t.decimal "amount_interest", default: "0.0"
    t.decimal "amount_fine", default: "0.0"
    t.decimal "amount_tax", default: "0.0"
    t.integer "status"
    t.index ["contract_id"], name: "index_contract_tickets_on_contract_id"
    t.index ["customer_id"], name: "index_contract_tickets_on_customer_id"
    t.index ["debtor_id"], name: "index_contract_tickets_on_debtor_id"
    t.index ["ticket_id"], name: "index_contract_tickets_on_ticket_id"
    t.index ["unit_id"], name: "index_contract_tickets_on_unit_id"
  end

  create_table "contracts", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "customer_id"
    t.integer "debtor_id"
    t.integer "user_id"
    t.decimal "amount_principal", default: "0.0"
    t.decimal "amount_monetary_correction", default: "0.0"
    t.decimal "amount_interest", default: "0.0"
    t.decimal "amount_fine", default: "0.0"
    t.decimal "amount_tax", default: "0.0"
    t.integer "status"
    t.integer "ticket_quantity"
    t.string "origin_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proposal_id"
    t.index ["customer_id"], name: "index_contracts_on_customer_id"
    t.index ["debtor_id"], name: "index_contracts_on_debtor_id"
    t.index ["proposal_id"], name: "index_contracts_on_proposal_id"
    t.index ["unit_id"], name: "index_contracts_on_unit_id"
    t.index ["user_id"], name: "index_contracts_on_user_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.string "name"
    t.index ["unit_id"], name: "index_courses_on_unit_id"
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "bank_account_id"
    t.string "full_name"
    t.string "name"
    t.string "cnpj"
    t.string "cpf"
    t.string "zipcode"
    t.string "city_name"
    t.string "state"
    t.string "address"
    t.integer "address_number"
    t.string "address_complement"
    t.string "neighborhood"
    t.string "email"
    t.string "phone_local_code"
    t.string "phone_number"
    t.string "mobile_local_code"
    t.string "mobile_number"
    t.string "origin_code"
    t.boolean "fl_charge_monetary_correction", default: true
    t.boolean "fl_charge_interest", default: true
    t.boolean "fl_charge_fine", default: true
    t.boolean "fl_charge_tax", default: true
    t.boolean "fl_show", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_customers_on_bank_account_id"
    t.index ["unit_id"], name: "index_customers_on_unit_id"
  end

  create_table "debtors", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "customer_id"
    t.string "name"
    t.string "cnpj"
    t.string "cpf"
    t.string "zipcode"
    t.string "city_name"
    t.string "state"
    t.string "address"
    t.integer "address_number"
    t.string "address_complement"
    t.string "neighborhood"
    t.string "email"
    t.string "phone_local_code"
    t.string "phone_number"
    t.string "mobile_local_code"
    t.string "mobile_number"
    t.string "origin_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_debtors_on_customer_id"
    t.index ["unit_id"], name: "index_debtors_on_unit_id"
  end

  create_table "histories", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "customer_id"
    t.integer "debtor_id"
    t.integer "user_id"
    t.string "description"
    t.datetime "history_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_histories_on_customer_id"
    t.index ["debtor_id"], name: "index_histories_on_debtor_id"
    t.index ["unit_id"], name: "index_histories_on_unit_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "monetary_indices", id: :serial, force: :cascade do |t|
    t.date "index_at"
    t.decimal "value", precision: 5, scale: 4
  end

  create_table "proposal_tickets", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "proposal_id"
    t.integer "ticket_type"
    t.float "amount"
    t.integer "ticket_number"
    t.date "due_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_proposal_tickets_on_proposal_id"
    t.index ["unit_id"], name: "index_proposal_tickets_on_unit_id"
  end

  create_table "proposals", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "user_id"
    t.integer "debtor_id"
    t.float "unit_amount"
    t.float "unit_fee"
    t.integer "unit_ticket_quantity"
    t.integer "client_ticket_quantity"
    t.float "client_amount"
    t.date "unit_due_at"
    t.date "client_due_at"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "contract_id"
    t.integer "customer_id"
    t.index ["contract_id"], name: "index_proposals_on_contract_id"
    t.index ["customer_id"], name: "index_proposals_on_customer_id"
    t.index ["debtor_id"], name: "index_proposals_on_debtor_id"
    t.index ["unit_id"], name: "index_proposals_on_unit_id"
    t.index ["user_id"], name: "index_proposals_on_user_id"
  end

  create_table "students", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "customer_id"
    t.integer "debtor_id"
    t.integer "course_id"
    t.string "name"
    t.string "cpf"
    t.index ["course_id"], name: "index_students_on_course_id"
    t.index ["customer_id"], name: "index_students_on_customer_id"
    t.index ["debtor_id"], name: "index_students_on_debtor_id"
    t.index ["unit_id"], name: "index_students_on_unit_id"
  end

  create_table "tickets", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.integer "customer_id"
    t.integer "debtor_id"
    t.integer "student_id"
    t.integer "contract_id"
    t.integer "course_id"
    t.string "description"
    t.decimal "amount_principal", default: "0.0"
    t.string "document_number"
    t.date "due_at"
    t.boolean "charge", default: false
    t.string "origin_code"
    t.integer "sequence"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proposal_id"
    t.index ["contract_id"], name: "index_tickets_on_contract_id"
    t.index ["course_id"], name: "index_tickets_on_course_id"
    t.index ["customer_id"], name: "index_tickets_on_customer_id"
    t.index ["debtor_id"], name: "index_tickets_on_debtor_id"
    t.index ["proposal_id"], name: "index_tickets_on_proposal_id"
    t.index ["student_id"], name: "index_tickets_on_student_id"
    t.index ["unit_id"], name: "index_tickets_on_unit_id"
  end

  create_table "units", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "cnpj_cpf"
    t.string "zipcode"
    t.string "state"
    t.string "city_name"
    t.string "address"
    t.string "address_complement"
    t.integer "address_number"
    t.string "neighborhood"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "profile"
    t.string "name"
    t.string "origin_code"
    t.integer "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unit_id"], name: "index_users_on_unit_id"
  end

  add_foreign_key "bank_accounts", "units"
  add_foreign_key "bank_slips", "bank_accounts"
  add_foreign_key "bank_slips", "contract_tickets"
  add_foreign_key "bank_slips", "contracts"
  add_foreign_key "bank_slips", "customers"
  add_foreign_key "bank_slips", "debtors"
  add_foreign_key "bank_slips", "units"
  add_foreign_key "contract_tickets", "contracts"
  add_foreign_key "contract_tickets", "customers"
  add_foreign_key "contract_tickets", "debtors"
  add_foreign_key "contract_tickets", "tickets"
  add_foreign_key "contract_tickets", "units"
  add_foreign_key "contracts", "customers"
  add_foreign_key "contracts", "debtors"
  add_foreign_key "contracts", "proposals"
  add_foreign_key "contracts", "units"
  add_foreign_key "contracts", "users"
  add_foreign_key "courses", "units"
  add_foreign_key "customers", "bank_accounts"
  add_foreign_key "customers", "units"
  add_foreign_key "debtors", "customers"
  add_foreign_key "debtors", "units"
  add_foreign_key "histories", "customers"
  add_foreign_key "histories", "debtors"
  add_foreign_key "histories", "units"
  add_foreign_key "histories", "users"
  add_foreign_key "proposal_tickets", "proposals"
  add_foreign_key "proposal_tickets", "units"
  add_foreign_key "proposals", "contracts"
  add_foreign_key "proposals", "customers"
  add_foreign_key "proposals", "debtors"
  add_foreign_key "proposals", "units"
  add_foreign_key "proposals", "users"
  add_foreign_key "students", "courses"
  add_foreign_key "students", "customers"
  add_foreign_key "students", "debtors"
  add_foreign_key "students", "units"
  add_foreign_key "tickets", "contracts"
  add_foreign_key "tickets", "courses"
  add_foreign_key "tickets", "customers"
  add_foreign_key "tickets", "debtors"
  add_foreign_key "tickets", "proposals"
  add_foreign_key "tickets", "students"
  add_foreign_key "tickets", "units"
  add_foreign_key "users", "units"
end
