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

ActiveRecord::Schema.define(version: 20151120103643) do

  create_table "apps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "plattform"
    t.string   "title"
    t.integer  "user_id"
  end

  create_table "collaborations", force: :cascade do |t|
    t.string   "lang"
    t.integer  "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "baselang"
    t.string   "title"
  end

  add_index "collaborations", ["app_id"], name: "index_collaborations_on_app_id"

  create_table "languages", force: :cascade do |t|
    t.string   "title"
    t.boolean  "in_work"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["app_id"], name: "index_languages_on_app_id"

  create_table "nodes", force: :cascade do |t|
    t.text     "title"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "parent_id"
    t.string   "lang"
    t.boolean  "list",       default: false
    t.integer  "app_id"
    t.string   "listtype"
  end

  add_index "nodes", ["app_id"], name: "index_nodes_on_app_id"
  add_index "nodes", ["parent_id"], name: "index_nodes_on_parent_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
    t.integer  "app"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
