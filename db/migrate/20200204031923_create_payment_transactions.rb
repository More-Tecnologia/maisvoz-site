class CreatePaymentTransactions < ActiveRecord::Migration[5.2]
  def change
    drop_table :payment_transactions
    create_table :payment_transactions do |t|
      t.references :order
      t.integer    :status, default: 0
      t.string     :transaction_id, unique: true, index: true
      t.decimal    :amount
      t.text       :provider_response

      t.timestamps
    end
  end
end
