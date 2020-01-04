class AddActiveToFinancialReasons < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_reasons, :active, :boolean, default: true
  end
end
