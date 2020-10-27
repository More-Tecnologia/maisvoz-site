class UpdateBonusContractItemForeighKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :bonus_contract_items, :financial_transactions
    add_foreign_key :bonus_contract_items, :financial_transactions, on_delete: :cascade
  end
end
