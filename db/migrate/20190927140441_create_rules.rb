class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.references :rule_type, foreign_key: true
      t.string :title, unique: true
      t.text :description

      t.timestamps
    end
  end
end
