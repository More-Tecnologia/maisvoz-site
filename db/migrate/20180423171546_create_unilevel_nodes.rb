class CreateUnilevelNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :unilevel_nodes do |t|
      t.references :user, index: { unique: true }, foreign_key: true, unique: true, null: false
      t.string :username
      t.string :career_kind
      t.boolean :leader, null: false, default: false
      t.string :ancestry, limit: 300

      t.timestamps
    end
    add_index :unilevel_nodes, :ancestry
  end
end
