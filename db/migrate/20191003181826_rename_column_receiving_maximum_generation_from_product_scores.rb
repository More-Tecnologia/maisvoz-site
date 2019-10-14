class RenameColumnReceivingMaximumGenerationFromProductScores < ActiveRecord::Migration[5.2]
  def change
    rename_column :product_scores, :receiving_maximum_generation, :generation
  end
end
