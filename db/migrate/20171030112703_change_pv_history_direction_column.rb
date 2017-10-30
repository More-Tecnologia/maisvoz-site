class ChangePvHistoryDirectionColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :pv_histories, :direction, :string, default: 'left', null: false
  end
end
