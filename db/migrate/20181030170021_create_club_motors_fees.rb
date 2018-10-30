class CreateClubMotorsFees < ActiveRecord::Migration[5.1]
  def change
    create_table :club_motors_fees do |t|
      t.string :name
      t.integer :standard_fee_cents
      t.integer :master_fee_cents
      t.integer :premium_fee_cents

      t.timestamps
    end
  end
end
