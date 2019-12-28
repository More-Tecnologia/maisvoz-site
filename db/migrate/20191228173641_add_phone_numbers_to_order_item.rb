class AddPhoneNumbersToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :cellphone_number, :string
  end
end
