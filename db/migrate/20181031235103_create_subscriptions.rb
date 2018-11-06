class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :subscriptionable, polymorphic: true, index: { name: 'index_subscriptionable_id_and_type' }
      t.string :status
      t.datetime :current_period_start
      t.datetime :current_period_end

      t.timestamps
    end
  end
end
