class CreateRuleTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :rule_types do |t|
      t.string :title
      t.text :description
      t.string :ruleable_name, unique: true

      t.timestamps
    end
  end
end
