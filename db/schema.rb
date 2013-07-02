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

ActiveRecord::Schema.define(version: 20130702215552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "albums", force: true do |t|
    t.string   "title"
    t.string   "label"
    t.date     "release_year"
    t.string   "format"
    t.string   "matrix"
    t.string   "catalog_number"
    t.string   "sticker"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_ref"
    t.boolean  "compilation"
    t.string   "spotify_uri"
  end

  create_table "artists", force: true do |t|
    t.string   "name"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_ref"
    t.string   "spotify_uri"
  end

  create_table "favorites", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lyric_occurences", force: true do |t|
    t.integer  "lyric_id"
    t.integer  "track_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "spotify_offset"
  end

  create_table "lyrics", force: true do |t|
    t.text     "body"
    t.string   "external_ref"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "track_participations", force: true do |t|
    t.integer  "artist_id"
    t.integer  "track_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "principal"
  end

  create_table "tracks", force: true do |t|
    t.string   "title"
    t.integer  "album_id"
    t.string   "palo"
    t.string   "style"
    t.integer  "duration"
    t.text     "details"
    t.string   "audio_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spotify_uri"
    t.integer  "guitar_fret"
    t.string   "guitar_key"
    t.string   "external_ref"
  end

end
