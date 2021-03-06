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

ActiveRecord::Schema.define(version: 20160328170531) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rez_addresses", force: :cascade do |t|
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

  create_table "rez_items", force: :cascade do |t|
    t.text     "title"
    t.text     "heading"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
    t.integer  "point_ids",  default: [], array: true
  end

  create_table "rez_items_points", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "point_id"
  end

  add_index "rez_items_points", ["item_id"], name: "index_rez_items_points_on_item_id", using: :btree
  add_index "rez_items_points", ["point_id"], name: "index_rez_items_points_on_point_id", using: :btree

  create_table "rez_items_resumes", id: false, force: :cascade do |t|
    t.integer "resume_id"
    t.integer "item_id"
  end

  add_index "rez_items_resumes", ["item_id"], name: "index_rez_items_resumes_on_item_id", using: :btree
  add_index "rez_items_resumes", ["resume_id"], name: "index_rez_items_resumes_on_resume_id", using: :btree

  create_table "rez_items_subitems", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "subitem_id"
  end

  add_index "rez_items_subitems", ["item_id"], name: "index_rez_items_subitems_on_item_id", using: :btree
  add_index "rez_items_subitems", ["subitem_id"], name: "index_rez_items_subitems_on_subitem_id", using: :btree

  create_table "rez_points", force: :cascade do |t|
    t.text     "text"
    t.integer  "point_type"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rez_profiles", force: :cascade do |t|
    t.string   "firstname",  limit: 32
    t.string   "middlename", limit: 32
    t.string   "lastname",   limit: 32
    t.string   "nickname",   limit: 32
    t.string   "prefix",     limit: 6
    t.string   "suffix",     limit: 6
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "rez_resumes", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
    t.integer  "section_ids", default: [], array: true
    t.integer  "user_id"
  end

  add_index "rez_resumes", ["user_id"], name: "index_rez_resumes_on_user_id", using: :btree

  create_table "rez_sections", force: :cascade do |t|
    t.text     "name"
    t.text     "heading"
    t.text     "subheading"
    t.integer  "item_ids",   default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "toke_tokens", force: :cascade do |t|
    t.string   "key"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "toke_tokens", ["key"], name: "index_toke_tokens_on_key", unique: true, using: :btree
  add_index "toke_tokens", ["user_id"], name: "index_toke_tokens_on_user_id", using: :btree

  create_table "toke_users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
