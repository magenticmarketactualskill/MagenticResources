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

ActiveRecord::Schema[8.1].define(version: 2026_01_19_004138) do
  create_table "assignments", force: :cascade do |t|
    t.integer "allocation_percentage", default: 100
    t.integer "assigned_by_id"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.text "notes"
    t.integer "project_id", null: false
    t.integer "resource_id", null: false
    t.string "role"
    t.date "start_date"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["assigned_by_id"], name: "index_assignments_on_assigned_by_id"
    t.index ["project_id", "resource_id"], name: "index_assignments_on_project_id_and_resource_id", unique: true
    t.index ["project_id"], name: "index_assignments_on_project_id"
    t.index ["resource_id"], name: "index_assignments_on_resource_id"
    t.index ["status"], name: "index_assignments_on_status"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.date "end_date"
    t.string "external_id"
    t.string "external_system"
    t.string "name", null: false
    t.integer "owner_id"
    t.integer "priority", default: 1
    t.date "start_date"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["external_system", "external_id"], name: "index_projects_on_external_system_and_external_id", unique: true, where: "external_id IS NOT NULL"
    t.index ["owner_id"], name: "index_projects_on_owner_id"
    t.index ["priority"], name: "index_projects_on_priority"
    t.index ["status"], name: "index_projects_on_status"
  end

  create_table "resource_skills", force: :cascade do |t|
    t.boolean "certified", default: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.integer "proficiency_level", default: 1
    t.integer "resource_id", null: false
    t.integer "skill_id", null: false
    t.datetime "updated_at", null: false
    t.integer "years_experience", default: 0
    t.index ["resource_id", "skill_id"], name: "index_resource_skills_on_resource_id_and_skill_id", unique: true
    t.index ["resource_id"], name: "index_resource_skills_on_resource_id"
    t.index ["skill_id"], name: "index_resource_skills_on_skill_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "avatar_url"
    t.integer "capacity_hours", default: 40
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.text "description"
    t.string "email"
    t.decimal "hourly_rate", precision: 10, scale: 2
    t.json "metadata", default: {}
    t.string "name", null: false
    t.integer "resource_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "timezone", default: "UTC"
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_resources_on_created_by_id"
    t.index ["email"], name: "index_resources_on_email"
    t.index ["resource_type"], name: "index_resources_on_resource_type"
    t.index ["status"], name: "index_resources_on_status"
  end

  create_table "skills", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_skills_on_name", unique: true
  end

  create_table "team_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "joined_at"
    t.integer "resource_id", null: false
    t.integer "role", default: 0
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_team_memberships_on_resource_id"
    t.index ["team_id", "resource_id"], name: "index_team_memberships_on_team_id_and_resource_id", unique: true
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "owner_id", null: false
    t.integer "team_type", default: 0
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name"
    t.index ["owner_id"], name: "index_teams_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "last_signed_in_at"
    t.integer "login_method"
    t.string "name"
    t.integer "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "assignments", "projects"
  add_foreign_key "assignments", "resources"
  add_foreign_key "assignments", "users", column: "assigned_by_id"
  add_foreign_key "projects", "users", column: "owner_id"
  add_foreign_key "resource_skills", "resources"
  add_foreign_key "resource_skills", "skills"
  add_foreign_key "resources", "users", column: "created_by_id"
  add_foreign_key "team_memberships", "resources"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "teams", "users", column: "owner_id"
end
