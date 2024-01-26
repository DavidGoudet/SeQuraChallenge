# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_26_174551) do
  create_table "disbursements", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "fee", precision: 10, scale: 2
    t.date "disbursement_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "email"
    t.string "reference"
    t.string "internal_id", null: false
    t.date "live_on"
    t.decimal "minimum_monthly_fee", precision: 10, scale: 2
    t.string "disbursement_frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["internal_id"], name: "index_merchants_on_internal_id", unique: true
    t.index ["reference"], name: "index_merchants_on_reference", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.string "internal_id", null: false
    t.integer "merchant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["internal_id"], name: "index_orders_on_internal_id", unique: true
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  add_foreign_key "disbursements", "merchants"
end
