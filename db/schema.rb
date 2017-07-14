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

ActiveRecord::Schema.define(version: 20170710133004) do

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

  create_table "careers", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.integer "qualifying_score", default: 0
    t.integer "bonus", default: 0
    t.integer "binary_limit", default: 0
    t.integer "order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "cloudinary_images", force: :cascade do |t|
    t.string "public_id"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_cloudinary_images_on_imageable_type_and_imageable_id"
  end

  create_table "financial_entries", force: :cascade do |t|
    t.string "description"
    t.bigint "amount_cents", default: 0, null: false
    t.integer "kind", default: 0
    t.jsonb "metadata"
    t.bigint "from_id"
    t.bigint "to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id"], name: "index_financial_entries_on_from_id"
    t.index ["kind"], name: "index_financial_entries_on_kind"
    t.index ["to_id"], name: "index_financial_entries_on_to_id"
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
    t.integer "payment_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "short_description"
    t.string "sku", limit: 10
    t.integer "quantity"
    t.integer "low_stock_alert"
    t.decimal "weight", precision: 10, scale: 2
    t.integer "length"
    t.integer "width"
    t.integer "height"
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
    t.index ["career_id"], name: "index_products_on_career_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["upgrade_from_career_id"], name: "index_products_on_upgrade_from_career_id"
    t.index ["upgrade_to_career_id"], name: "index_products_on_upgrade_to_career_id"
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
    t.string "name"
    t.string "phone"
    t.string "skype"
    t.bigint "sponsor_id"
    t.string "username", null: false
    t.string "document_value"
    t.date "birthdate"
    t.string "address"
    t.string "address_2"
    t.string "country"
    t.string "state"
    t.string "city"
    t.integer "role", default: 0, null: false
    t.integer "binary_strategy", default: 0
    t.integer "binary_position"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sponsor_id"], name: "index_users_on_sponsor_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "withdrawals", force: :cascade do |t|
    t.bigint "amount_cents", null: false
    t.integer "status", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "binary_nodes", "users"
  add_foreign_key "binary_nodes", "users", column: "sponsored_by_id"
  add_foreign_key "financial_entries", "accounts", column: "from_id"
  add_foreign_key "financial_entries", "accounts", column: "to_id"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "careers"
  add_foreign_key "products", "categories"
  add_foreign_key "withdrawals", "users"
end
