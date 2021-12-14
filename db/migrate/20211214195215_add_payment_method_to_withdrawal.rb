class AddPaymentMethodToWithdrawal < ActiveRecord::Migration[5.2]
  def change
    add_column :withdrawals, :payment_method, :integer, default: 0
  end
end
