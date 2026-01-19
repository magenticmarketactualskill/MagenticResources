class CreateResourceSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :resource_skills do |t|
      t.references :resource, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.integer :proficiency_level, default: 1
      t.integer :years_experience, default: 0
      t.boolean :certified, default: false
      t.text :notes

      t.timestamps
    end

    add_index :resource_skills, [:resource_id, :skill_id], unique: true
  end
end
