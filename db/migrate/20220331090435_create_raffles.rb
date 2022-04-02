# frozen_string_literal: true

class CreateRaffles < ActiveRecord::Migration[5.2]
  def change
    create_table :raffles do |t|
      t.date :draw_date
      t.integer :kind,                     null: false, default: 0
      t.integer :max_ticket_number,        null: false, default: 0
      t.integer :status,                   null: false, default: 0
      t.string :lotto_numbers,             array: true, default: []
      t.string :lotto_numbers_combination,              default: ''
      t.string :title,                     null: false

      t.references :product
      t.references :winner
      t.references :winning_ticket

      t.timestamps
    end
  end
end
