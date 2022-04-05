# frozen_string_literal: true

class AddOrderItemReferenceToRaffleTickets < ActiveRecord::Migration[5.2]
  def change
    add_reference :raffle_tickets, :order_item, foreign_key: true
  end
end
