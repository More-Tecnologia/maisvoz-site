class AddMorenwmMoneyFlowToFinancialReasons < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_reasons, :morenwm_moneyflow, :integer, default: 0
  end
end
