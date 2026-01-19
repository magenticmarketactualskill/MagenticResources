class CreateTeams < ActiveRecord::Migration[8.1]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.text :description
      t.integer :team_type, default: 0
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :teams, :name
  end
end
