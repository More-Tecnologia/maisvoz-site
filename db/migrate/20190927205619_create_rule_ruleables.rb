class CreateRuleRuleables < ActiveRecord::Migration[5.2]
  def change
    create_table :rule_ruleables do |t|
      t.references :rule, foreign_key: true
      t.references :ruleable, polymorphic: true

      t.timestamps
    end
  end
end
