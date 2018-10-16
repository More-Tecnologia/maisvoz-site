class AddProductToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :product, foreign_key: true, index: true
  end
end
