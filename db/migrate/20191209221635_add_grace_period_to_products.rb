class AddGracePeriodToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :grace_period, :integer, default: 0
  end
end
