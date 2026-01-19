class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.string :category
      t.text :description

      t.timestamps
    end
    add_index :skills, :name, unique: true
  end
end
