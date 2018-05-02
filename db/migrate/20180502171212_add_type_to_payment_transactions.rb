class AddTypeToPaymentTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_transactions, :type, :string
    add_index :payment_transactions, :type
  end
end
