class ChangePvHistoryDirectionColumn < ActiveRecord::Migration[5.1]
  def up
    change_column :pv_histories, :direction, :string, default: 'left', null: false
  end

  def down
    remove_column :pv_histories, :direction
    add_column :pv_histories, :direction, :integer, default: 0, null: false
  end
end
