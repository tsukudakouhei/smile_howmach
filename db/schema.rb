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

ActiveRecord::Schema.define(version: 2023_04_19_135905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mac_menus", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "smile_analysis_scores", force: :cascade do |t|
    t.integer "smile_score"
    t.integer "eye_expression_score"
    t.integer "mouth_expression_score"
    t.integer "nose_position_score"
    t.integer "jawline_score"
    t.integer "naturalness_and_balance_score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "smile_prices", force: :cascade do |t|
    t.integer "price"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "body"
    t.boolean "is_published", default: false, null: false
    t.bigint "smile_analysis_score_id"
    t.index ["smile_analysis_score_id"], name: "index_smile_prices_on_smile_analysis_score_id"
    t.index ["user_id"], name: "index_smile_prices_on_user_id"
  end

  create_table "smileprices_macdmenus", force: :cascade do |t|
    t.bigint "smile_price_id", null: false
    t.bigint "mac_menu_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mac_menu_id"], name: "index_smileprices_macdmenus_on_mac_menu_id"
    t.index ["smile_price_id"], name: "index_smileprices_macdmenus_on_smile_price_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "smile_prices", "smile_analysis_scores"
  add_foreign_key "smile_prices", "users"
  add_foreign_key "smileprices_macdmenus", "mac_menus"
  add_foreign_key "smileprices_macdmenus", "smile_prices"
end
