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

ActiveRecord::Schema.define(version: 2019_03_12_054611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", force: :cascade do |t|
    t.string "destination", null: false
    t.string "short_code", null: false
    t.string "admin_code", null: false
    t.integer "use_count", default: 0, null: false
    t.jsonb "user_agents", default: {}
    t.jsonb "day_of_week", default: {}
    t.jsonb "hour_of_day", default: {}
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_code"], name: "index_links_on_admin_code"
    t.index ["day_of_week"], name: "index_links_on_day_of_week"
    t.index ["hour_of_day"], name: "index_links_on_hour_of_day"
    t.index ["short_code"], name: "index_links_on_short_code"
    t.index ["user_agents"], name: "index_links_on_user_agents"
  end

end
