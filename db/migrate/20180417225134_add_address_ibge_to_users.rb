class AddAddressIbgeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :address_ibge, :string
  end
end
