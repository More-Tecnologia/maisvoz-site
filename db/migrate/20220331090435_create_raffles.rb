# frozen_string_literal: true

class CreateRaffles < ActiveRecord::Migration[5.2]
  def change
    create_table :raffles do |t|
      t.string :title, null: false
      t.integer :kind, null: false, default: 0
      t.integer :max_ticket_number, null: false, default: 0
      t.date :draw_date
      t.string :lotto_numbers, array: true, default: ['']
      t.string :lotto_numbers_combination, default: ''
      t.references :product
      t.references :winner_id
      t.references :winning_ticket_id

      t.timestamps
    end
  end
end
