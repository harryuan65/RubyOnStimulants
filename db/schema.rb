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

ActiveRecord::Schema.define(version: 2020_10_19_072545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "currency"
    t.integer "price"
    t.string "content"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "articles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", null: false
    t.text "content", null: false
    t.integer "like_count", default: 0
    t.integer "view_count", default: 0
    t.integer "comment_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.string "subtitle"
    t.integer "comments_count"
    t.index ["comment_count"], name: "index_articles_on_comment_count"
    t.index ["like_count"], name: "index_articles_on_like_count"
    t.index ["state"], name: "index_articles_on_state"
    t.index ["title"], name: "index_articles_on_title"
    t.index ["user_id"], name: "index_articles_on_user_id"
    t.index ["view_count"], name: "index_articles_on_view_count"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "article_id"
    t.integer "thread_id"
    t.text "message", null: false
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["thread_id"], name: "index_comments_on_thread_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "definitions", force: :cascade do |t|
    t.bigint "word_id"
    t.string "def_org", null: false
    t.string "tag"
    t.string "zh_tw_translation", null: false
    t.string "part_of_speech", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["def_org"], name: "index_definitions_on_def_org"
    t.index ["part_of_speech"], name: "index_definitions_on_part_of_speech"
    t.index ["word_id", "def_org", "zh_tw_translation", "part_of_speech"], name: "index_on_definition_fields", unique: true
    t.index ["word_id"], name: "index_definitions_on_word_id"
  end

  create_table "examples", force: :cascade do |t|
    t.bigint "word_id"
    t.bigint "definition_id"
    t.string "sentence", null: false
    t.string "translation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["definition_id"], name: "index_examples_on_definition_id"
    t.index ["word_id", "definition_id"], name: "index_examples_on_word_id_and_definition_id"
    t.index ["word_id"], name: "index_examples_on_word_id"
  end

  create_table "gutentag_taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_gutentag_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id", "tag_id"], name: "unique_taggings", unique: true
    t.index ["taggable_type", "taggable_id"], name: "index_gutentag_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "gutentag_tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0, null: false
    t.index ["name"], name: "index_gutentag_tags_on_name", unique: true
    t.index ["taggings_count"], name: "index_gutentag_tags_on_taggings_count"
  end

  create_table "onb_line_users", force: :cascade do |t|
    t.string "line_uid"
    t.string "display_name"
    t.string "picture_url"
    t.string "status_message"
    t.string "language"
    t.boolean "archived", default: false
    t.datetime "blocked_channel_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_uid"], name: "index_onb_line_users_on_line_uid", unique: true
  end

  create_table "supplies", force: :cascade do |t|
    t.string "name"
    t.integer "category"
    t.integer "quantity"
    t.datetime "earliest_expiration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "to_do_lists", force: :cascade do |t|
    t.string "thing"
    t.boolean "done"
    t.string "postscript"
    t.datetime "deadline"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_to_do_lists_on_user_id"
  end

  create_table "user_word_ships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "word_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fb_uid"
    t.string "fb_token"
    t.string "google_uid"
    t.string "google_token"
    t.string "name"
    t.string "image_url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_words_on_name", unique: true
  end

end
