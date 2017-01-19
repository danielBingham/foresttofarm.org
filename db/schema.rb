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

ActiveRecord::Schema.define(version: 20160917161832) do

  create_table "common_names", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "plant_id", null: false, unsigned: true
    t.string  "name"
    t.index ["plant_id"], name: "plant_id", using: :btree
  end

  create_table "drawbacks", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
  end

  create_table "habitats", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
  end

  create_table "habits", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "symbol"
    t.text   "description", limit: 65535
    t.index ["name"], name: "name", using: :btree
  end

  create_table "harvest_types", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
  end

  create_table "harvests", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "plant_id",        null: false, unsigned: true
    t.integer "harvest_type_id", null: false, unsigned: true
    t.integer "rating",                       unsigned: true
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "height"
    t.integer "width"
    t.string  "attribution"
    t.string  "extension"
    t.integer "plant_id"
    t.index ["plant_id"], name: "index_images_on_plant_id", using: :btree
  end

  create_table "light_tolerances", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
  end

  create_table "moisture_tolerances", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
  end

  create_table "plants", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "genus"
    t.string   "species"
    t.string   "family"
    t.float    "minimum_PH",     limit: 24
    t.float    "maximum_PH",     limit: 24
    t.float    "minimum_height", limit: 24
    t.float    "maximum_height", limit: 24
    t.float    "minimum_width",  limit: 24
    t.float    "maximum_width",  limit: 24
    t.string   "minimum_zone",   limit: 2
    t.string   "maximum_zone",   limit: 2
    t.string   "growth_rate",    limit: 3
    t.string   "form",           limit: 5
    t.string   "native_region",  limit: 4
    t.index ["genus"], name: "genus", using: :btree
    t.index ["species"], name: "species", using: :btree
  end

  create_table "plants_drawbacks", primary_key: ["drawback_id", "plant_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "plant_id",    null: false, unsigned: true
    t.integer "drawback_id", null: false, unsigned: true
  end

  create_table "plants_habitats", primary_key: ["habitat_id", "plant_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "plant_id",   null: false, unsigned: true
    t.integer "habitat_id", null: false, unsigned: true
  end

  create_table "plants_habits", primary_key: ["habit_id", "plant_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "habit_id", null: false, unsigned: true
    t.integer "plant_id", null: false, unsigned: true
  end

  create_table "plants_light_tolerances", primary_key: ["plant_id", "light_tolerance_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "plant_id",           null: false, unsigned: true
    t.integer "light_tolerance_id", null: false, unsigned: true
  end

  create_table "plants_moisture_tolerances", primary_key: ["moisture_tolerance_id", "plant_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "plant_id",              null: false, unsigned: true
    t.integer "moisture_tolerance_id", null: false, unsigned: true
  end

  create_table "plants_roles", primary_key: ["plant_id", "role_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "plant_id", null: false, unsigned: true
    t.integer "role_id",  null: false, unsigned: true
  end

  create_table "plants_root_patterns", primary_key: ["root_pattern_id", "plant_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "root_pattern_id", null: false, unsigned: true
    t.integer "plant_id",        null: false, unsigned: true
  end

  create_table "roles", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
  end

  create_table "root_patterns", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "symbol"
    t.string "description"
    t.index ["name"], name: "name", using: :btree
  end

end
