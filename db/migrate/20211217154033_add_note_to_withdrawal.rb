class AddNoteToWithdrawal < ActiveRecord::Migration[5.2]
  def change
    add_column :withdrawals, :note, :string, default: ''
  end
end
