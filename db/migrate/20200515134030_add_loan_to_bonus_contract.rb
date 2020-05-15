class AddLoanToBonusContract < ActiveRecord::Migration[5.2]
  def change
    add_column :bonus_contracts, :loan, :boolean, default: false
    add_column :bonus_contracts, :inactived_loan_at, :datetime
  end
end
