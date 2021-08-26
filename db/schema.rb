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

ActiveRecord::Schema.define(version: 2021_08_25_220922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "speed_tests", force: :cascade do |t|
    t.string "url", null: false
    t.string "email", null: false
    t.string "gtmetrix_test_id"
    t.string "gtmetrix_report_id"
    t.string "gtmetrix_report_url"
    t.binary "gtmetrix_report_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
