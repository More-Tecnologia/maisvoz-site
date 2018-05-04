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

ActiveRecord::Schema.define(version: 20180504201529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "available_balance_cents", default: 0, null: false
    t.bigint "blocked_balance_cents", default: 0, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attachinary_files", force: :cascade do |t|
    t.string "attachinariable_type"
    t.bigint "attachinariable_id"
    t.string "scope"
    t.string "public_id"
    t.string "version"
    t.integer "width"
    t.integer "height"
    t.string "format"
    t.string "resource_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent"
    t.index ["attachinariable_type", "attachinariable_id"], name: "index_on_type_and_id"
  end

  create_table "binary_nodes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sponsored_by_id"
    t.bigint "parent_id"
    t.bigint "left_child_id"
    t.bigint "right_child_id"
    t.bigint "left_pv", default: 0
    t.bigint "right_pv", default: 0
    t.bigint "left_count", default: 0
    t.bigint "right_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["left_child_id"], name: "index_binary_nodes_on_left_child_id"
    t.index ["parent_id"], name: "index_binary_nodes_on_parent_id"
    t.index ["right_child_id"], name: "index_binary_nodes_on_right_child_id"
    t.index ["sponsored_by_id"], name: "index_binary_nodes_on_sponsored_by_id"
    t.index ["user_id"], name: "index_binary_nodes_on_user_id", unique: true
  end

  create_table "bonus", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.string "kind", null: false
    t.bigint "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_bonus_on_kind"
    t.index ["order_id"], name: "index_bonus_on_order_id"
    t.index ["user_id"], name: "index_bonus_on_user_id"
  end

  create_table "career_histories", force: :cascade do |t|
    t.bigint "user_id"
    t.string "old_career"
    t.string "new_career"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_career_histories_on_user_id"
  end

  create_table "careers", force: :cascade do |t|
    t.string "name"
    t.integer "qualifying_score", default: 0
    t.integer "bonus", default: 0
    t.integer "binary_limit", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0, null: false
    t.decimal "binary_percentage", precision: 5, scale: 2, default: "0.0", null: false
    t.string "image_path"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "order", default: 0
    t.boolean "active_session", default: true
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credits", force: :cascade do |t|
    t.bigint "operated_by_id"
    t.bigint "user_id", null: false
    t.string "message"
    t.bigint "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operated_by_id"], name: "index_credits_on_operated_by_id"
    t.index ["user_id"], name: "index_credits_on_user_id"
  end

  create_table "debits", force: :cascade do |t|
    t.bigint "operated_by_id"
    t.bigint "user_id", null: false
    t.string "message"
    t.bigint "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operated_by_id"], name: "index_debits_on_operated_by_id"
    t.index ["user_id"], name: "index_debits_on_user_id"
  end

  create_table "financial_entries", force: :cascade do |t|
    t.string "description"
    t.bigint "amount_cents", default: 0, null: false
    t.bigint "balance_cents", default: 0, null: false
    t.string "kind", default: "0"
    t.bigint "user_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_financial_entries_on_kind"
    t.index ["order_id"], name: "index_financial_entries_on_order_id"
    t.index ["user_id"], name: "index_financial_entries_on_user_id"
  end

  create_table "options", force: :cascade do |t|
    t.string "option_name"
    t.string "option_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "quantity", default: 0
    t.integer "unit_price_cents", default: 0
    t.integer "total_cents", default: 0
    t.bigint "order_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "subtotal_cents", default: 0
    t.integer "tax_cents", default: 0
    t.integer "shipping_cents", default: 0
    t.integer "total_cents", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "paid_at"
    t.bigint "pv_total", default: 0, null: false
    t.boolean "sap_recorded", default: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.string "boleto_url"
    t.string "boleto_barcode"
    t.datetime "boleto_expiration_date"
    t.string "status"
    t.bigint "pagarme_tid"
    t.bigint "amount_cents"
    t.bigint "paid_amount_cents", default: 0
    t.integer "installments", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.text "provider_response"
    t.index ["order_id"], name: "index_payment_transactions_on_order_id"
    t.index ["pagarme_tid"], name: "index_payment_transactions_on_pagarme_tid", unique: true, where: "(pagarme_tid IS NOT NULL)"
    t.index ["status"], name: "index_payment_transactions_on_status"
    t.index ["type"], name: "index_payment_transactions_on_type"
    t.index ["user_id"], name: "index_payment_transactions_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "short_description"
    t.string "sku", limit: 10
    t.string "quantity"
    t.integer "low_stock_alert"
    t.decimal "weight", precision: 10, scale: 2
    t.decimal "length", precision: 10, scale: 2
    t.decimal "width", precision: 10, scale: 2
    t.decimal "height", precision: 10, scale: 2
    t.bigint "price_cents"
    t.integer "binary_score"
    t.integer "advance_score"
    t.boolean "active"
    t.boolean "virtual"
    t.integer "paid_by"
    t.bigint "category_id"
    t.bigint "career_id"
    t.integer "bonus_1"
    t.integer "bonus_2"
    t.integer "bonus_3"
    t.integer "bonus_4"
    t.integer "bonus_5"
    t.integer "bonus_6"
    t.integer "bonus_7"
    t.integer "bonus_8"
    t.integer "bonus_9"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind"
    t.bigint "upgrade_from_career_id"
    t.bigint "upgrade_to_career_id"
    t.string "sap_code"
    t.index ["career_id"], name: "index_products_on_career_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["sap_code"], name: "index_products_on_sap_code", unique: true
    t.index ["upgrade_from_career_id"], name: "index_products_on_upgrade_from_career_id"
    t.index ["upgrade_to_career_id"], name: "index_products_on_upgrade_to_career_id"
  end

  create_table "pv_activity_histories", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.integer "amount", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "balance", default: 0, null: false
    t.string "kind"
    t.bigint "height"
    t.index ["order_id"], name: "index_pv_activity_histories_on_order_id"
    t.index ["user_id", "order_id"], name: "index_pv_activity_histories_on_user_id_and_order_id", unique: true
    t.index ["user_id"], name: "index_pv_activity_histories_on_user_id"
  end

  create_table "pv_histories", force: :cascade do |t|
    t.bigint "order_id"
    t.string "direction", default: "left", null: false
    t.bigint "amount_cents", default: 0, null: false
    t.bigint "balance_cents", default: 0, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "origin_username"
    t.index ["order_id"], name: "index_pv_histories_on_order_id"
    t.index ["user_id"], name: "index_pv_histories_on_user_id"
  end

  create_table "system_financial_logs", force: :cascade do |t|
    t.string "description"
    t.bigint "amount_cents"
    t.string "kind"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_system_financial_logs_on_order_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.bigint "from_user_id", null: false
    t.bigint "to_user_id", null: false
    t.bigint "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_transfers_on_from_user_id"
    t.index ["to_user_id"], name: "index_transfers_on_to_user_id"
  end

  create_table "unilevel_nodes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "username"
    t.string "career_kind"
    t.boolean "leader", default: false, null: false
    t.string "ancestry", limit: 300
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_unilevel_nodes_on_ancestry"
    t.index ["user_id"], name: "index_unilevel_nodes_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sponsor_id"
    t.string "name"
    t.string "marital_status"
    t.string "gender"
    t.string "phone"
    t.string "skype"
    t.string "username", null: false
    t.string "registration_type"
    t.string "document_cpf"
    t.string "document_rg"
    t.string "document_pis"
    t.string "document_cnpj"
    t.string "document_ie"
    t.string "document_company_name"
    t.string "document_fantasy_name"
    t.date "birthdate"
    t.string "zipcode"
    t.string "address_number"
    t.string "district"
    t.string "address"
    t.string "address_2"
    t.string "country"
    t.string "state"
    t.string "city"
    t.bigint "available_balance_cents", default: 0, null: false
    t.bigint "blocked_balance_cents", default: 0, null: false
    t.string "role", default: "consumidor", null: false
    t.string "binary_strategy", default: "balanced_strategy", null: false
    t.string "binary_position"
    t.boolean "bought_adhesion", default: false, null: false
    t.boolean "bought_product", default: false, null: false
    t.string "career_kind"
    t.bigint "pva_total", default: 0, null: false
    t.boolean "active", default: false, null: false
    t.date "active_until"
    t.boolean "binary_qualified", default: false, null: false
    t.string "bank_account"
    t.string "bank_agency"
    t.string "bank_code"
    t.string "address_ibge"
    t.string "document_refused_reason"
    t.string "document_verification_status"
    t.datetime "document_verification_updated_at"
    t.string "document_rg_expeditor"
    t.index ["career_kind"], name: "index_users_on_career_kind"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["document_cpf"], name: "index_users_on_document_cpf", unique: true
    t.index ["document_verification_status"], name: "index_users_on_document_verification_status"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sponsor_id"], name: "index_users_on_sponsor_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "withdrawals", force: :cascade do |t|
    t.string "status", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gross_amount_cents", null: false
    t.bigint "net_amount_cents", null: false
    t.string "fiscal_document_link"
    t.index ["status"], name: "index_withdrawals_on_status"
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "binary_nodes", "users"
  add_foreign_key "binary_nodes", "users", column: "sponsored_by_id"
  add_foreign_key "bonus", "orders"
  add_foreign_key "bonus", "users"
  add_foreign_key "career_histories", "users"
  add_foreign_key "credits", "users"
  add_foreign_key "credits", "users", column: "operated_by_id"
  add_foreign_key "debits", "users"
  add_foreign_key "debits", "users", column: "operated_by_id"
  add_foreign_key "financial_entries", "orders"
  add_foreign_key "financial_entries", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "payment_transactions", "orders"
  add_foreign_key "payment_transactions", "users"
  add_foreign_key "products", "careers"
  add_foreign_key "products", "categories"
  add_foreign_key "pv_activity_histories", "orders"
  add_foreign_key "pv_activity_histories", "users"
  add_foreign_key "pv_histories", "orders"
  add_foreign_key "pv_histories", "users"
  add_foreign_key "system_financial_logs", "orders"
  add_foreign_key "transfers", "users", column: "from_user_id"
  add_foreign_key "transfers", "users", column: "to_user_id"
  add_foreign_key "unilevel_nodes", "users"
  add_foreign_key "withdrawals", "users"
end
