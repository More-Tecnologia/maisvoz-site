class CreateProductReasonScores < ActiveRecord::Migration[5.2]
  def change
    create_table :product_reason_scores do |t|
      t.references :product, foreign_key: true
      t.references :financial_reason, foreign_key: true
      t.references :product_score, foreign_key: true

      t.timestamps
    end
  end
end
