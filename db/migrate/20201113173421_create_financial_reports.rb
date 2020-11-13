class CreateFinancialReports < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_reports do |t|
      t.integer :order_payment_amount_cents
      t.integer :pool_amount_cents
      t.integer :withdrawal_amount_cents
      t.integer :pool_balance_amount_cents
      t.integer :profit_amount_cents
      t.integer :profit_per_partner_amount_cents
      t.datetime :begin_datetime
      t.datetime :end_datetime

      t.timestamps
    end
  end
end
