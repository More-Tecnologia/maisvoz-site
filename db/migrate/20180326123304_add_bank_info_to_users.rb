class AddBankInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bank_account, :string
    add_column :users, :bank_agency, :string
    add_column :users, :bank_code, :string
  end
end
