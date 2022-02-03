class CreateReaction < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.integer :emotion, null: false
      t.references :reactable, polymorphic: true, index: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
