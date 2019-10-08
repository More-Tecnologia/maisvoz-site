class RemoveProductRefFromProductReasonScores < ActiveRecord::Migration[5.2]
  def change
    remove_column :product_reason_scores, :product_score_id
  end
end
