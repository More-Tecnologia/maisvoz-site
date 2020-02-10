class CreateBonusContractItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bonus_contract_items do |t|
      t.references :financial_transaction, foreign_key: true
      t.bigint :cent_amount
      t.references :bonus_contract

      t.timestamps
    end
  end
end
