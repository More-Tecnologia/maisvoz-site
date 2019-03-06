class AddOrderToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_reference :vouchers, :order, foreign_key: true
    add_column :vouchers, :invoice_type, :string
    add_column :vouchers, :used_at, :datetime
  end
end
