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
  create_enum "trackable_systems_name", ["radar4kit", "radar4chem", "chemotion_repository", "chemotion_electronic_laboratory_notebook", "nmrxiv"]
  create_enum "trackings_status", ["draft", "published", "submitted", "reviewing", "pending", "accepted", "reviewed", "rejected", "deleted"]
  create_enum "users_role", ["user", "super", "admin"]

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.text "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id", unique: true
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", unique: true
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.bigint "resource_owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_owner_id"], name: "index_oauth_applications_on_resource_owner_id"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "trackable_systems", force: :cascade do |t|
    t.enum "name", null: false, enum_type: "trackable_systems_name"
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
    t.enum "status", null: false, enum_type: "trackings_status"
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
    t.enum "role", null: false, enum_type: "users_role"
    t.text "email", null: false
    t.text "encrypted_password", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["encrypted_password"], name: "index_users_on_encrypted_password", unique: true
  end

  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "oauth_applications", "users", column: "resource_owner_id"
  add_foreign_key "tracking_items", "users"
  add_foreign_key "trackings", "trackable_systems", column: "from_trackable_system_id"
  add_foreign_key "trackings", "trackable_systems", column: "to_trackable_system_id"
  add_foreign_key "trackings", "tracking_items"
end
