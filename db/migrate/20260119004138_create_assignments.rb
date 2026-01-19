class CreateAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :assignments do |t|
      t.references :project, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true
      t.string :role
      t.integer :allocation_percentage, default: 100
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0
      t.references :assigned_by, foreign_key: { to_table: :users }
      t.text :notes

      t.timestamps
    end

    add_index :assignments, [:project_id, :resource_id], unique: true
    add_index :assignments, :status
  end
end
