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

ActiveRecord::Schema.define(version: 2018_10_31_005853) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "classroom_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taska_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taska_id"
    t.integer "month"
    t.integer "year"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer "rating"
    t.string "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taska_id"
    t.integer "classroom_id"
  end

  create_table "kids", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.integer "classroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "base_fee"
  end

  create_table "parents", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_parents_on_email", unique: true
    t.index ["reset_password_token"], name: "index_parents_on_reset_password_token", unique: true
    t.index ["username"], name: "index_parents_on_username", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bill_month"
    t.integer "bill_year"
    t.string "bill_id"
    t.string "description"
    t.string "state"
    t.boolean "paid"
    t.integer "kid_id"
    t.float "amount"
    t.integer "parent_id"
    t.integer "taska_id"
  end

  create_table "taska_admins", force: :cascade do |t|
    t.integer "taska_id"
    t.integer "admin_id"
  end

  create_table "taska_teachers", force: :cascade do |t|
    t.integer "taska_id"
    t.integer "teacher_id"
  end

  create_table "taskas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region"
    t.string "email"
    t.string "name"
    t.string "collection_id"
    t.index ["collection_id"], name: "index_taskas_on_collection_id", unique: true
    t.index ["email"], name: "index_taskas_on_email", unique: true
    t.index ["name"], name: "index_taskas_on_name", unique: true
  end

  create_table "teachers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
    t.index ["username"], name: "index_teachers_on_username", unique: true
  end

  create_table "teachers_classrooms", force: :cascade do |t|
    t.integer "teacher_id"
    t.integer "classroom_id"
  end

end
