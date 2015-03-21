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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150321172558) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "markets", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal  "min_price"
    t.decimal  "max_price"
    t.decimal  "first_bid"
    t.decimal  "first_bid_size"
    t.decimal  "first_offer"
    t.decimal  "first_offer_size"
    t.integer  "state"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "side",       default: 0
    t.integer  "state"
    t.decimal  "price"
    t.decimal  "size"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "size_left"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "orders_trades", id: false, force: :cascade do |t|
    t.integer "order_id"
    t.integer "trade_id"
  end

  add_index "orders_trades", ["order_id"], name: "index_orders_trades_on_order_id", using: :btree
  add_index "orders_trades", ["trade_id"], name: "index_orders_trades_on_trade_id", using: :btree

  create_table "trades", force: :cascade do |t|
    t.decimal "price"
    t.decimal "size"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_trades", id: false, force: :cascade do |t|
    t.integer "trade_id"
    t.integer "user_id"
  end

  add_index "users_trades", ["trade_id"], name: "index_users_trades_on_trade_id", using: :btree
  add_index "users_trades", ["user_id"], name: "index_users_trades_on_user_id", using: :btree

end
