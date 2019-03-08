class AddBankAccountTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bank_account_type, :string
  end
end
