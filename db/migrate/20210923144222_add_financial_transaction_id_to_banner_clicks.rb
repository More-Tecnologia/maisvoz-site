class AddFinancialTransactionIdToBannerClicks < ActiveRecord::Migration[5.2]
  def change
    add_column :banner_clicks, :financial_transaction_id, :integer
  end
end
