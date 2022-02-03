class CreateCourse < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.string :short_description, null: false
      t.string :language
      t.string :country_of_operation, array: true, default: [""], index: true
      t.integer :days_to_cashback, default: 0
      t.text :description, null: false
      t.text :content, null: false
      t.boolean :active, default: false
      t.boolean :approved, default: false
      t.references :product
      t.references :owner
      t.references :approver_user
    end
  end
end
