class CreateFinancialReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_reasons do |t|
      t.string :title, unique: true
      t.text :description

      t.timestamps
    end
  end
end
