class AddOrderOfServiceToPvActivityHistories < ActiveRecord::Migration[5.2]
  def change
    add_reference :pv_activity_histories, :order_of_service, foreign_key: true
  end
end
