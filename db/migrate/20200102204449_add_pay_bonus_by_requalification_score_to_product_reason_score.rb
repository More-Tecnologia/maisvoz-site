class AddPayBonusByRequalificationScoreToProductReasonScore < ActiveRecord::Migration[5.2]
  def change
    add_column :product_reason_scores, :pay_bonus_by_requalification_score, :boolean, default: false
  end
end
