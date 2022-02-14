class CreateItemCategorization < ActiveRecord::Migration[5.2]
  def change
    create_table :item_categorizations do |t|
      t.references :itemable
      t.references :categorization

      t.timestamps
    end
  end
end
