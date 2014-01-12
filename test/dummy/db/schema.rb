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

ActiveRecord::Schema.define(version: 20140112041007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rez_addresses", force: true do |t|
    t.text "building_number"
    t.text "street_name"
    t.text "secondary_address"
    t.text "city"
    t.text "state"
    t.text "zip_code"
    t.text "county"
    t.text "country"
    t.text "area_code"
    t.text "phone_number"
  end

  create_table "rez_items", force: true do |t|
    t.text     "title"
    t.text     "heading"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
    t.integer  "rank"
    t.boolean  "visible"
  end

  create_table "rez_points", force: true do |t|
    t.integer  "item_id"
    t.integer  "rank"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "point_type"
  end

  create_table "rez_profiles", force: true do |t|
    t.string   "firstname",  limit: 32
    t.string   "middlename", limit: 32
    t.string   "lastname",   limit: 32
    t.string   "nickname",   limit: 32
    t.string   "prefix",     limit: 6
    t.string   "suffix",     limit: 6
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rez_resumes", force: true do |t|
    t.integer  "profile_id"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
    t.integer  "item_ids",   default: [], array: true
  end

  create_table "toke_tokens", force: true do |t|
    t.string   "key"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "toke_tokens", ["key"], name: "index_toke_tokens_on_key", unique: true, using: :btree
  add_index "toke_tokens", ["user_id"], name: "index_toke_tokens_on_user_id", using: :btree

  create_table "toke_users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
