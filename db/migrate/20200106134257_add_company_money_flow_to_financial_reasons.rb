class AddCompanyMoneyFlowToFinancialReasons < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_reasons, :company_moneyflow, :integer, default: 0
  end
end
