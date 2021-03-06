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

ActiveRecord::Schema.define(version: 2019_05_23_152120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pokemons", force: :cascade do |t|
    t.string "name", null: false
    t.string "poke_type", null: false
    t.string "image_url"
    t.string "anime_url"
    t.integer "level", null: false
    t.bigint "professor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hp"
    t.integer "attack"
    t.integer "defense"
    t.string "ability1"
    t.string "ability2"
    t.integer "height"
    t.integer "weight"
    t.index ["professor_id"], name: "index_pokemons_on_professor_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "trainer_id", null: false
    t.bigint "pokemon_id", null: false
    t.string "enemy_name"
    t.string "enemy_type"
    t.integer "enemy_level"
    t.string "outcome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rating"
    t.text "comment"
    t.index ["pokemon_id"], name: "index_transfers_on_pokemon_id"
    t.index ["trainer_id"], name: "index_transfers_on_trainer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "image_url"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "pokemons", "users", column: "professor_id"
  add_foreign_key "transfers", "pokemons"
  add_foreign_key "transfers", "users", column: "trainer_id"
end
