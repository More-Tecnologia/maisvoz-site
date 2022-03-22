class AddClicksToProducts < ActiveRecord::Migration[5.2]
    def change
      add_column :products, :clicks, :integer
    end
  end
  