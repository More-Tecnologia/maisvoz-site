class AddInterspireCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :interspire_code, :string
  end
end
