class AddProviderResponseToPaymentTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_transactions, :provider_response, :text
  end
end
