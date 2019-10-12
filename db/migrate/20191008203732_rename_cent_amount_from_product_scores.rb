class RenameCentAmountFromProductScores < ActiveRecord::Migration[5.2]
  def change
    rename_column :product_scores, :cent_amount, :amount_cents
  end
end
