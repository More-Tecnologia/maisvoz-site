class CreatePoolTrandings < ActiveRecord::Migration[5.2]
  def change
    create_table :pool_trandings do |t|
      t.decimal :amount, default: 0

      t.timestamps
    end
  end
end
