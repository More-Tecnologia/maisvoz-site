class CreatePagarmeTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :pagarme_transactions do |t|
      t.references :order, foreign_key: true
      t.references :user, foreign_key: true
      t.string :boleto_url
      t.string :boleto_barcode
      t.datetime :boleto_expiration_date
      t.string :status
      t.bigint :pagarme_tid
      t.bigint :amount_cents
      t.bigint :paid_amount_cents, default: 0
      t.integer :installments, default: 1

      t.timestamps
    end
    add_index :pagarme_transactions, :status
    add_index :pagarme_transactions, :pagarme_tid, unique: true
  end
end
