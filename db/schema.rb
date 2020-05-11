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

ActiveRecord::Schema.define(version: 2020_05_10_155527) do

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
    t.integer "privacy", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_count"], name: "index_articles_on_comment_count"
    t.index ["like_count"], name: "index_articles_on_like_count"
    t.index ["privacy"], name: "index_articles_on_privacy"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocabs", force: :cascade do |t|
    t.string "word"
    t.string "meaning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "examples", default: [], array: true
  end

end
