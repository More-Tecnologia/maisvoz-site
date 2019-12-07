class CreatePaymentTransactions < ActiveRecord::Migration[5.2]
  def change
    # create_table :payment_transactions do |t|
    #   t.references :order, foreign_key: true
    #   t.references :user, foreign_key: true
    #   t.string :boleto_url
    #   t.string :boleto_barcode
    #   t.datetime :boleto_expiration_date
    #   t.string :status
    #   t.bigint :amount_cents
    #   t.bigint :paid_amount_cents, default: 0
    #   t.integer :installments, default: 1
    #   t.string :type
    #   t.text :provider_response
    #
    #   t.timestamps
    # end
    #
    # add_index :payment_transactions, :status
    # add_index :payment_transactions, :type
  end
end
