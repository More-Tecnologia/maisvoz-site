class CreateCategorization < ActiveRecord::Migration[5.2]
  def change
    create_table :categorizations do |t|
      t.boolean :active, default: true
      t.string :title, null: false
      t.string :tag, null: false

      t.timestamps
    end
  end
end
