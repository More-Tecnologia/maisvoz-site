class AddBinaryPercentageToCareers < ActiveRecord::Migration[5.1]
  def change
    add_column :careers, :binary_percentage, :decimal, precision: 5, scale: 2, default: 0.00, null: false
  end
end
