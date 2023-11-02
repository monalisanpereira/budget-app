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

ActiveRecord::Schema[7.0].define(version: 2023_11_01_235932) do
  create_table "budget_assignees", force: :cascade do |t|
    t.integer "budget_id", null: false
    t.integer "user_id", null: false
    t.integer "percentage"
    t.index ["budget_id"], name: "index_budget_assignees_on_budget_id"
    t.index ["user_id"], name: "index_budget_assignees_on_user_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.integer "family_id", null: false
    t.string "name"
    t.decimal "amount"
    t.integer "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_budgets_on_family_id"
  end

  create_table "expenditure_assignees", force: :cascade do |t|
    t.integer "expenditure_id", null: false
    t.integer "user_id", null: false
    t.integer "percentage"
    t.index ["expenditure_id"], name: "index_expenditure_assignees_on_expenditure_id"
    t.index ["user_id"], name: "index_expenditure_assignees_on_user_id"
  end

  create_table "expenditures", force: :cascade do |t|
    t.integer "budget_id"
    t.text "description"
    t.decimal "amount"
    t.integer "created_by"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_expenditures_on_budget_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "family_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "family_members", force: :cascade do |t|
    t.integer "family_id", null: false
    t.integer "user_id", null: false
    t.boolean "is_owner", default: false, null: false
    t.integer "role"
    t.index ["family_id"], name: "index_family_members_on_family_id"
    t.index ["user_id"], name: "index_family_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "user_username", unique: true
  end

  add_foreign_key "budget_assignees", "budgets"
  add_foreign_key "budget_assignees", "users"
  add_foreign_key "budgets", "families"
  add_foreign_key "expenditure_assignees", "expenditures"
  add_foreign_key "expenditure_assignees", "users"
  add_foreign_key "expenditures", "budgets"
  add_foreign_key "family_members", "families"
  add_foreign_key "family_members", "users"
end
