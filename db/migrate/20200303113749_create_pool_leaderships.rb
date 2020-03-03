class CreatePoolLeaderships < ActiveRecord::Migration[5.2]
  def change
    create_table :pool_leaderships do |t|
      t.decimal :amount, default: 0

      t.timestamps
    end
  end
end
