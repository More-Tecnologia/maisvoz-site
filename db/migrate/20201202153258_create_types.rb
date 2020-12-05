class CreateTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :types do |t|
      t.string :name
      t.integer :indications_quantity, default: 0
      t.decimal :bonus_percentage, default: 0
      t.boolean :qualify_by_user_activity, default: false

      t.timestamps
    end
  end
end
