class AddStockOutAtToSimCards < ActiveRecord::Migration[5.2]
  def change
    add_column :sim_cards, :stock_out_at, :datetime
  end
end
