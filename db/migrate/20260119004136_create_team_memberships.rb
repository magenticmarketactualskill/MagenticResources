class CreateTeamMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :team_memberships do |t|
      t.references :team, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true
      t.integer :role, default: 0
      t.datetime :joined_at

      t.timestamps
    end

    add_index :team_memberships, [:team_id, :resource_id], unique: true
  end
end
