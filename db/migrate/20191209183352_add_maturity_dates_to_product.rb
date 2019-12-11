class AddMaturityDatesToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :maturity_days, :string
  end
end
