class CreateFinancialReasonTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_reason_types do |t|
      t.string :name
      t.string :code, unique: true, index: true

      t.timestamps
    end
  end
end
