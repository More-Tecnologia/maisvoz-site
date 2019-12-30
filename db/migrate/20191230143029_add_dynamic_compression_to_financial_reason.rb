class AddDynamicCompressionToFinancialReason < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_reasons, :dynamic_compression, :boolean, default: false
  end
end
