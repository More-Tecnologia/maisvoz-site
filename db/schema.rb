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

ActiveRecord::Schema.define(version: 20170526170030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["career_id"], name: "index_products_on_career_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  add_foreign_key "products", "careers"
  add_foreign_key "products", "categories"
end
