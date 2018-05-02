class RenamePagarmeTransactionToPaymentTransaction < ActiveRecord::Migration[5.1]
  def change
    remove_index :pagarme_transactions, :status
    remove_index :pagarme_transactions, :pagarme_tid

    rename_table :pagarme_transactions, :payment_transactions

    add_index :payment_transactions, :status
    add_index :payment_transactions, :pagarme_tid, unique: true, where: 'pagarme_tid IS NOT NULL'
  end
end
