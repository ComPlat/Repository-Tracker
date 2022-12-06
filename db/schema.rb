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

ActiveRecord::Schema[7.0].define(version: 2022_12_06_163114) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "tracking_status", ["draft", "published", "submitted", "reviewing", "pending", "accepted", "reviewed", "rejected", "deleted"]
  create_enum "user_roles", ["user", "super", "admin"]

  create_table "trackable_systems", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_trackable_systems_on_name", unique: true
  end

  create_table "tracking_items", force: :cascade do |t|
    t.text "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tracking_items_on_name", unique: true
    t.index ["user_id"], name: "index_tracking_items_on_user_id"
  end

  create_table "trackings", force: :cascade do |t|
    t.datetime "date_time", null: false
    t.enum "status", default: "draft", null: false, enum_type: "tracking_status"
    t.jsonb "metadata", null: false
    t.bigint "tracking_item_id", null: false
    t.bigint "from_trackable_system_id", null: false
    t.bigint "to_trackable_system_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_trackable_system_id"], name: "index_trackings_on_from_trackable_system_id"
    t.index ["to_trackable_system_id"], name: "index_trackings_on_to_trackable_system_id"
    t.index ["tracking_item_id"], name: "index_trackings_on_tracking_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "name", null: false
    t.enum "role", default: "user", null: false, enum_type: "user_roles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "tracking_items", "users"
  add_foreign_key "trackings", "trackable_systems", column: "from_trackable_system_id"
  add_foreign_key "trackings", "trackable_systems", column: "to_trackable_system_id"
  add_foreign_key "trackings", "tracking_items"
end
