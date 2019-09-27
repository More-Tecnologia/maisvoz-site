class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.references :order, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :spreader_user_id, foreign_key: true
      t.references :score_type, foreign_key: true
      t.integer :cent_amount, null: false
      t.integer :height
      t.integer :source_leg, default: 0

      t.timestamps
    end
  end
end
