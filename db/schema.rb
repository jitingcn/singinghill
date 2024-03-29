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

ActiveRecord::Schema[7.0].define(version: 2022_04_16_112705) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action", null: false
    t.bigint "user_id"
    t.bigint "record_id"
    t.string "record_type"
    t.text "payload"
    t.text "request"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["action"], name: "index_audit_logs_on_action"
    t.index ["record_type", "record_id"], name: "index_audit_logs_on_record_type_and_record_id"
    t.index ["user_id", "action"], name: "index_audit_logs_on_user_id_and_action"
  end

  create_table "entries", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "location", default: "", null: false
    t.text "source", null: false
    t.text "english", default: "", null: false
    t.text "chinese", default: "", null: false
    t.text "comment", default: "", null: false
    t.bigint "project_file_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "narrator_id", default: "", null: false
    t.integer "index"
    t.index ["chinese"], name: "index_entries_on_chinese"
    t.index ["chinese"], name: "trgm_index_on_entries_chinese", opclass: :gist_trgm_ops, using: :gist
    t.index ["english"], name: "trgm_index_on_entries_english", opclass: :gist_trgm_ops, using: :gist
    t.index ["project_file_id"], name: "index_entries_on_project_file_id"
    t.index ["source"], name: "index_entries_on_source"
    t.index ["source"], name: "trgm_index_on_entries_source", opclass: :gist_trgm_ops, using: :gist
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "narrators", force: :cascade do |t|
    t.string "narrator_id", null: false
    t.string "narrator_source", default: "", null: false
    t.string "narrator_chinese", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["narrator_chinese"], name: "index_narrators_on_narrator_chinese"
    t.index ["narrator_id"], name: "index_narrators_on_narrator_id"
    t.index ["narrator_source"], name: "index_narrators_on_narrator_source"
  end

  create_table "nouns", force: :cascade do |t|
    t.string "source", null: false
    t.string "english", default: "", null: false
    t.string "chinese", default: "", null: false
    t.string "leixing", default: "", null: false
    t.text "comment", default: "", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source"], name: "index_nouns_on_source"
    t.index ["user_id"], name: "index_nouns_on_user_id"
  end

  create_table "project_files", force: :cascade do |t|
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "title"
    t.index ["name"], name: "index_project_files_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nickname"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.integer "role", default: 0, null: false
    t.string "authentication_token"
    t.jsonb "extra", default: {}
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.datetime "created_at", precision: nil
    t.jsonb "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "entries", "project_files"
  add_foreign_key "entries", "users"
  add_foreign_key "nouns", "users"
end
