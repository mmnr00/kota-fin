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

ActiveRecord::Schema.define(version: 2018_12_29_020229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", id: :integer, default: nil, force: :cascade do |t|
    t.text "email", default: "", null: false
    t.text "encrypted_password", default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "username"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "classrooms", id: :integer, default: nil, force: :cascade do |t|
    t.text "classroom_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taska_id"
    t.string "description"
    t.float "base_fee"
  end

  create_table "college_admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_college_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_college_admins_on_reset_password_token", unique: true
    t.index ["username"], name: "index_college_admins_on_username", unique: true
  end

  create_table "colleges", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_colleges_on_collection_id", unique: true
    t.index ["name"], name: "index_colleges_on_name", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "college_id"
    t.float "base_fee"
    t.string "description"
  end

  create_table "expenses", id: :integer, default: nil, force: :cascade do |t|
    t.text "name"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taska_id"
    t.integer "month"
    t.integer "year"
    t.string "kind"
  end

  create_table "extras", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.integer "taska_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", id: :integer, default: nil, force: :cascade do |t|
    t.integer "rating"
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taska_id"
    t.integer "classroom_id"
  end

  create_table "fotos", force: :cascade do |t|
    t.string "picture"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tchdetail_id"
    t.string "foto_name"
    t.integer "kid_id"
    t.integer "taska_id"
  end

  create_table "kid_bills", force: :cascade do |t|
    t.integer "kid_id"
    t.integer "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "classroom_id"
    t.text "extra"
  end

  create_table "kid_extras", force: :cascade do |t|
    t.integer "kid_id"
    t.integer "extra_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kids", id: :integer, default: nil, force: :cascade do |t|
    t.text "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ic_1"
    t.string "ic_2"
    t.string "ic_3"
    t.date "dob"
    t.string "birth_place"
    t.string "arr_infam"
    t.string "allergy"
    t.string "fav_food"
    t.string "hobby"
    t.string "panel_clinic"
    t.string "mother_name"
    t.string "mother_phone"
    t.string "mother_job"
    t.string "mother_job_address"
    t.string "father_name"
    t.string "father_phone"
    t.string "father_job"
    t.string "father_job_address"
    t.string "income"
    t.string "alt_phone"
    t.date "date_enter"
    t.integer "taska_id"
    t.integer "classroom_id"
    t.string "gender"
    t.string "ph_1"
    t.string "ph_2"
  end

  create_table "kidtsks", force: :cascade do |t|
    t.integer "kid_id"
    t.integer "taska_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owner_colleges", force: :cascade do |t|
    t.integer "owner_id"
    t.integer "college_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
    t.index ["username"], name: "index_owners_on_username", unique: true
  end

  create_table "parents", id: :integer, default: nil, force: :cascade do |t|
    t.text "email", default: "", null: false
    t.text "encrypted_password", default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "username"
    t.index ["email"], name: "index_parents_on_email", unique: true
    t.index ["reset_password_token"], name: "index_parents_on_reset_password_token", unique: true
    t.index ["username"], name: "index_parents_on_username", unique: true
  end

  create_table "payments", id: :integer, default: nil, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bill_month"
    t.integer "bill_year"
    t.text "bill_id"
    t.text "description"
    t.text "state"
    t.boolean "paid"
    t.integer "kid_id"
    t.float "amount"
    t.integer "parent_id"
    t.integer "taska_id"
    t.integer "course_id"
    t.integer "teacher_id"
    t.string "name"
    t.boolean "reminder"
    t.float "discount"
  end

  create_table "prntdetails", force: :cascade do |t|
    t.string "name"
    t.string "ic_1"
    t.string "ic_2"
    t.string "ic_3"
    t.string "phone_1"
    t.string "phone_2"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "states"
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
  end

  create_table "ptnssps", force: :cascade do |t|
    t.string "name"
    t.string "strgh"
    t.string "wkns"
    t.string "opp"
    t.string "thr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "siblings", force: :cascade do |t|
    t.bigint "kid_id"
    t.bigint "beradik_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beradik_id"], name: "index_siblings_on_beradik_id"
    t.index ["kid_id"], name: "index_siblings_on_kid_id"
  end

  create_table "taska_admins", id: :integer, default: nil, force: :cascade do |t|
    t.integer "taska_id"
    t.integer "admin_id"
  end

  create_table "taska_teachers", id: :integer, default: nil, force: :cascade do |t|
    t.integer "taska_id"
    t.integer "teacher_id"
  end

  create_table "taskas", id: :integer, default: nil, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "email"
    t.string "phone_1"
    t.string "phone_2"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "states"
    t.string "postcode"
    t.string "supervisor"
    t.string "bank_name"
    t.string "acc_no"
    t.string "acc_name"
    t.string "ssm_no"
    t.string "collection_id"
    t.string "name"
    t.string "plan"
    t.string "bank_status"
    t.string "billplz_reg"
    t.datetime "expire"
    t.float "booking"
    t.string "subdomain"
    t.index ["email"], name: "index_taskas_on_email", unique: true
    t.index ["subdomain"], name: "index_taskas_on_subdomain", unique: true
  end

  create_table "tchdetails", force: :cascade do |t|
    t.string "name"
    t.string "ic_1"
    t.string "ic_2"
    t.string "ic_3"
    t.string "phone_1"
    t.string "phone_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "marital"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "states"
    t.string "postcode"
    t.string "education"
    t.integer "teacher_id"
    t.string "ts_name"
    t.string "ts_address_1"
    t.string "ts_address_2"
    t.string "ts_city"
    t.string "ts_states"
    t.string "ts_postcode"
    t.string "ts_owner_name"
    t.string "ts_phone_1"
    t.string "ts_phone_2"
  end

  create_table "teacher_colleges", force: :cascade do |t|
    t.integer "teacher_id"
    t.integer "college_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teacher_courses", force: :cascade do |t|
    t.integer "teacher_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", id: :integer, default: nil, force: :cascade do |t|
    t.text "email", default: "", null: false
    t.text "encrypted_password", default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "username"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
    t.index ["username"], name: "index_teachers_on_username", unique: true
  end

  create_table "teachers_classrooms", id: :integer, default: nil, force: :cascade do |t|
    t.integer "teacher_id"
    t.integer "classroom_id"
  end

end
