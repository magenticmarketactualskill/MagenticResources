class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, default: 0
      t.integer :priority, default: 1
      t.date :start_date
      t.date :end_date
      t.references :owner, foreign_key: { to_table: :users }
      t.string :external_id
      t.string :external_system

      t.timestamps
    end

    add_index :projects, :status
    add_index :projects, :priority
    add_index :projects, [:external_system, :external_id], unique: true, where: "external_id IS NOT NULL"
  end
end
