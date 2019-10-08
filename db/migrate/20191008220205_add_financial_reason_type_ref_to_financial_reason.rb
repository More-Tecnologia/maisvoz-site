class AddFinancialReasonTypeRefToFinancialReason < ActiveRecord::Migration[5.2]
  def change
    add_reference :financial_reasons, :financial_reason_type, foreign_key: true
  end
end
