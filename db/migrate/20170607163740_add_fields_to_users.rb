class AddFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :sponsor, index: true
    add_column :users, :name, :string
    add_column :users, :marital_status, :string
    add_column :users, :gender, :string
    add_column :users, :phone, :string
    add_column :users, :skype, :string
    add_column :users, :username, :string, null: false
    add_column :users, :registration_type, :string
    add_column :users, :document_cpf, :string
    add_column :users, :document_rg, :string
    add_column :users, :document_pis, :string
    add_column :users, :document_cnpj, :string
    add_column :users, :document_ie, :string
    add_column :users, :document_company_name, :string
    add_column :users, :document_fantasy_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :zipcode, :string
    add_column :users, :address_number, :string
    add_column :users, :district, :string
    add_column :users, :address, :string
    add_column :users, :address_2, :string
    add_column :users, :country, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :available_balance_cents, :bigint, default: 0, null: false
    add_column :users, :blocked_balance_cents, :bigint, default: 0, null: false

    add_index :users, :username, unique: true
  end
end
