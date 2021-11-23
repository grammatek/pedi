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

ActiveRecord::Schema.define(version: 2021_11_20_174951) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "dictionaries", force: :cascade do |t|
    t.string "name"
    t.datetime "edited"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sampa_id"
    t.integer "version", default: 1
    t.index ["sampa_id"], name: "index_dictionaries_on_sampa_id"
  end

  create_table "entries", force: :cascade do |t|
    t.string "word"
    t.string "sampa"
    t.string "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "dictionary_id"
    t.boolean "finished"
    t.boolean "warning"
    t.string "pos"
    t.string "lang", default: "IS"
    t.boolean "is_compound", default: false
    t.string "comp_part"
    t.boolean "prefix", default: false
    t.string "dialect"
    t.index ["comp_part"], name: "index_entries_on_comp_part"
    t.index ["dialect"], name: "index_entries_on_dialect"
    t.index ["dictionary_id"], name: "index_entries_on_dictionary_id"
    t.index ["is_compound"], name: "index_entries_on_is_compound"
    t.index ["lang"], name: "index_entries_on_lang"
    t.index ["pos"], name: "index_entries_on_pos"
    t.index ["prefix"], name: "index_entries_on_prefix"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "sampas", force: :cascade do |t|
    t.string "name"
    t.text "phonemes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "dictionary_id"
    t.index ["dictionary_id"], name: "index_sampas_on_dictionary_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.boolean "admin", default: false
    t.string "tts_voice"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dictionaries", "sampas"
  add_foreign_key "entries", "dictionaries"
  add_foreign_key "entries", "users"
  add_foreign_key "sampas", "dictionaries"
end
