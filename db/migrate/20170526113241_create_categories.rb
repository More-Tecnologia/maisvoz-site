class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.integer :order, default: 0
      t.boolean :active_session, default: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
