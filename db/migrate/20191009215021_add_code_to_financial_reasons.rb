class AddCodeToFinancialReasons < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_reasons, :code, :string, unique: true, index: true
  end
end
