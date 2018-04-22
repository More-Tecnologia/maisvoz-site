class AddOriginUsernameToPvHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :pv_histories, :origin_username, :string
  end
end
