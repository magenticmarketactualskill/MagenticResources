class CreateResources < ActiveRecord::Migration[8.1]
  def change
    create_table :resources do |t|
      t.string :name, null: false
      t.integer :resource_type, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.string :email
      t.string :avatar_url
      t.text :description
      t.decimal :hourly_rate, precision: 10, scale: 2
      t.integer :capacity_hours, default: 40
      t.string :timezone, default: "UTC"
      t.json :metadata, default: {}
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :resources, :email
    add_index :resources, :resource_type
    add_index :resources, :status
  end
end
