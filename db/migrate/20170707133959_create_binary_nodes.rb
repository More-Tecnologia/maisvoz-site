class CreateBinaryNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :binary_nodes do |t|
      t.references :user, index: {unique: true}, foreign_key: true, null: false
      t.references :sponsored_by, index: true, foreign_key: { to_table: :users }
      t.references :parent, index: true
      t.references :left_child, index: true
      t.references :right_child, index: true
      t.bigint :left_pv, default: 0
      t.bigint :right_pv, default: 0
      t.bigint :left_count, default: 0
      t.bigint :right_count, default: 0

      t.timestamps
    end
  end
end
