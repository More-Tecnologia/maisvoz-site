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

ActiveRecord::Schema.define(version: 2019_10_08_203732) do

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

  create_table "career_trail_users", force: :cascade do |t|
    t.bigint "career_trail_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["career_trail_id"], name: "index_career_trail_users_on_career_trail_id"
    t.index ["user_id"], name: "index_career_trail_users_on_user_id"
  end

  create_table "career_trails", force: :cascade do |t|
    t.bigint "career_id"
    t.bigint "trail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["career_id"], name: "index_career_trails_on_career_id"
    t.index ["trail_id"], name: "index_career_trails_on_trail_id"
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

  create_table "cities", force: :cascade do |t|
    t.string "state"
    t.string "name"
    t.integer "ibge"
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

  create_table "financial_reasons", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "financial_transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "financial_reason_id"
    t.integer "spreader_id"
    t.integer "moneyflow", default: 0
    t.integer "cent_amount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.integer "financial_transaction_id"
    t.integer "generation"
    t.index ["financial_reason_id"], name: "index_financial_transactions_on_financial_reason_id"
    t.index ["order_id"], name: "index_financial_transactions_on_order_id"
    t.index ["spreader_id"], name: "index_financial_transactions_on_spreader_id"
    t.index ["user_id"], name: "index_financial_transactions_on_user_id"
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
    t.boolean "dr_recorded", default: false
    t.text "dr_response"
    t.date "expire_at"
    t.string "payment_type"
    t.string "paid_by"
    t.string "payable_type"
    t.bigint "payable_id"
    t.boolean "billed", default: false
    t.index ["payable_type", "payable_id"], name: "index_orders_on_payable_type_and_payable_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_reason_scores", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "financial_reason_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["financial_reason_id"], name: "index_product_reason_scores_on_financial_reason_id"
    t.index ["product_id"], name: "index_product_reason_scores_on_product_id"
  end

  create_table "product_scores", force: :cascade do |t|
    t.integer "generation"
    t.integer "amount_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "career_trail_id"
    t.boolean "fix_value", default: false
    t.bigint "product_reason_score_id"
    t.index ["career_trail_id"], name: "index_product_scores_on_career_trail_id"
    t.index ["product_reason_score_id"], name: "index_product_scores_on_product_reason_score_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind"
    t.decimal "binary_bonus"
    t.bigint "trail_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["trail_id"], name: "index_products_on_trail_id"
  end

  create_table "pv_activity_histories", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "amount", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "balance", default: 0, null: false
    t.string "kind"
    t.bigint "height"
    t.index ["order_id"], name: "index_pv_activity_histories_on_order_id"
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

  create_table "rule_ruleables", force: :cascade do |t|
    t.bigint "rule_id"
    t.string "ruleable_type"
    t.bigint "ruleable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_id"], name: "index_rule_ruleables_on_rule_id"
    t.index ["ruleable_type", "ruleable_id"], name: "index_rule_ruleables_on_ruleable_type_and_ruleable_id"
  end

  create_table "rule_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "ruleable_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rules", force: :cascade do |t|
    t.bigint "rule_type_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_type_id"], name: "index_rules_on_rule_type_id"
  end

  create_table "score_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tree_type", default: 0
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.integer "spreader_user_id"
    t.bigint "score_type_id"
    t.integer "cent_amount", null: false
    t.integer "height"
    t.integer "source_leg", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_scores_on_order_id"
    t.index ["score_type_id"], name: "index_scores_on_score_type_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
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

  create_table "trails", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "product_id"
    t.string "bank_account_type"
    t.text "ascendant_sponsors_ids"
    t.index ["career_kind"], name: "index_users_on_career_kind"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["document_cpf"], name: "index_users_on_document_cpf", unique: true
    t.index ["document_verification_status"], name: "index_users_on_document_verification_status"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["product_id"], name: "index_users_on_product_id"
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
  add_foreign_key "career_trail_users", "career_trails"
  add_foreign_key "career_trail_users", "users"
  add_foreign_key "career_trails", "careers"
  add_foreign_key "career_trails", "trails"
  add_foreign_key "credits", "users"
  add_foreign_key "credits", "users", column: "operated_by_id"
  add_foreign_key "debits", "users"
  add_foreign_key "debits", "users", column: "operated_by_id"
  add_foreign_key "financial_entries", "orders"
  add_foreign_key "financial_entries", "users"
  add_foreign_key "financial_transactions", "financial_reasons"
  add_foreign_key "financial_transactions", "orders"
  add_foreign_key "financial_transactions", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "product_reason_scores", "financial_reasons"
  add_foreign_key "product_reason_scores", "products"
  add_foreign_key "product_scores", "career_trails"
  add_foreign_key "product_scores", "product_reason_scores"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "trails"
  add_foreign_key "pv_activity_histories", "orders"
  add_foreign_key "pv_activity_histories", "users"
  add_foreign_key "pv_histories", "orders"
  add_foreign_key "pv_histories", "users"
  add_foreign_key "rule_ruleables", "rules"
  add_foreign_key "rules", "rule_types"
  add_foreign_key "scores", "orders"
  add_foreign_key "scores", "score_types"
  add_foreign_key "scores", "users"
  add_foreign_key "system_financial_logs", "orders"
  add_foreign_key "transfers", "users", column: "from_user_id"
  add_foreign_key "transfers", "users", column: "to_user_id"
  add_foreign_key "unilevel_nodes", "users"
  add_foreign_key "users", "products"
  add_foreign_key "withdrawals", "users"
end
