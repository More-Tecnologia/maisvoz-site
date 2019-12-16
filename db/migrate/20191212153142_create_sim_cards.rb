class CreateSimCards < ActiveRecord::Migration[5.2]
  def change
    create_table :sim_cards do |t|
      t.string :iccid
      t.string :phone_number
      t.integer :status, default: 0
      t.datetime :status_change_date
      t.references :user
      t.bigint :support_point_user_id, index: true, foreign_key: true
      t.references :order_item

      t.timestamps
    end
  end
end
