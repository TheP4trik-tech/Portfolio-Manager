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

ActiveRecord::Schema[8.1].define(version: 2026_06_16_122609) do
  create_table "api_credentials", force: :cascade do |t|
    t.string "api_id"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.string "provider"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_api_credentials_on_user_id"
  end

  create_table "cash_snapshots", force: :cascade do |t|
    t.decimal "available_cash"
    t.datetime "created_at", null: false
    t.string "currency"
    t.decimal "profit_loss"
    t.decimal "total_balance"
    t.decimal "total_investments"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_cash_snapshots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "password"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "surname"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "api_credentials", "users"
  add_foreign_key "cash_snapshots", "users"
end
