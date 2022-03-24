class CreateReview < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :stars_quantity, null: false
      t.string :title
      t.text :comment
      t.boolean :banned, default: false
      t.references :reviewable
      t.references :user

      t.timestamps
    end
  end
end
