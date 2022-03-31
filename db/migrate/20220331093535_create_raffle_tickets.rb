# frozen_string_literal: true

class CreateRaffleTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :raffle_tickets do |t|
      t.string :number, null: false

      t.references :raffle
      t.references :user

      t.timestamps
    end
  end
end
