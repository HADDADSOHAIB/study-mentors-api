# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_03_142704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.bigint "student_id", null: false
    t.date "date"
    t.time "from"
    t.time "to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "session_type"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_bookings_on_category_id"
    t.index ["student_id"], name: "index_bookings_on_student_id"
    t.index ["teacher_id"], name: "index_bookings_on_teacher_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "join_category_teachers", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_join_category_teachers_on_category_id"
    t.index ["teacher_id"], name: "index_join_category_teachers_on_teacher_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "email"
    t.string "phone"
    t.string "fullname"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_students_on_email", unique: true
  end

  create_table "teachers", force: :cascade do |t|
    t.string "fullname"
    t.string "email"
    t.string "phone"
    t.text "bio"
    t.text "what_I_can_do"
    t.json "schedule"
    t.string "session_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.text "photo"
    t.index ["email"], name: "index_teachers_on_email", unique: true
  end

  add_foreign_key "bookings", "students"
  add_foreign_key "bookings", "teachers"
  add_foreign_key "join_category_teachers", "categories"
  add_foreign_key "join_category_teachers", "teachers"
end
