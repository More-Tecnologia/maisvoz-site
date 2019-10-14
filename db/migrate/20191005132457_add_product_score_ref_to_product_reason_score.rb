class AddProductScoreRefToProductReasonScore < ActiveRecord::Migration[5.2]
  def change
    add_reference :product_scores, :product_reason_score, foreign_key: true
  end
end
