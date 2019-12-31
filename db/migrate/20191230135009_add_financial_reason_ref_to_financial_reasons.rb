class AddFinancialReasonRefToFinancialReasons < ActiveRecord::Migration[5.2]
  def change
    add_reference :financial_reasons, :financial_reason
  end
end
