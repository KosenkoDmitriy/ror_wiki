# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150831184009) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "images", force: :cascade do |t|
    t.string   "title"
    t.string   "text"
    t.text     "url"
    t.text     "path"
    t.text     "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "moderations", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.text     "stext"
    t.boolean  "is_approved"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "date_time"
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key"

  create_table "sources", force: :cascade do |t|
    t.string   "title"
    t.text     "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string   "title"
    t.string   "text"
    t.string   "stext"
    t.boolean  "is_approved"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "date_time"
  end

  create_table "story_moderation_sources", force: :cascade do |t|
    t.integer  "moderation_id"
    t.integer  "source_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "story_moderation_sources", ["moderation_id"], name: "index_story_moderation_sources_on_moderation_id"
  add_index "story_moderation_sources", ["source_id"], name: "index_story_moderation_sources_on_source_id"

  create_table "story_moderation_topics", force: :cascade do |t|
    t.integer  "moderation_id"
    t.integer  "topic_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "story_moderation_topics", ["moderation_id"], name: "index_story_moderation_topics_on_moderation_id"
  add_index "story_moderation_topics", ["topic_id"], name: "index_story_moderation_topics_on_topic_id"

  create_table "story_moderations", force: :cascade do |t|
    t.integer  "story_id"
    t.integer  "moderation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "story_moderations", ["moderation_id"], name: "index_story_moderations_on_moderation_id"
  add_index "story_moderations", ["story_id"], name: "index_story_moderations_on_story_id"

  create_table "story_sources", force: :cascade do |t|
    t.integer  "story_id"
    t.integer  "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "story_sources", ["source_id"], name: "index_story_sources_on_source_id"
  add_index "story_sources", ["story_id"], name: "index_story_sources_on_story_id"

  create_table "topic_stories", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "story_id"
    t.datetime "date_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topic_stories", ["story_id"], name: "index_topic_stories_on_story_id"
  add_index "topic_stories", ["topic_id"], name: "index_topic_stories_on_topic_id"

  create_table "topics", force: :cascade do |t|
    t.string   "title"
    t.string   "text"
    t.string   "stext"
    t.boolean  "is_approved"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
