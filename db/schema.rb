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

ActiveRecord::Schema.define(version: 20150825130919) do

  create_table "images", force: :cascade do |t|
    t.string   "title"
    t.string   "text"
    t.text     "url"
    t.text     "path"
    t.text     "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
  end

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

end
