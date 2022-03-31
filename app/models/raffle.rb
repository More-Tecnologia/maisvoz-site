# frozen_string_literal: true

class Raffle < ApplicationRecord
  enum kind: { started: 0, awaiting_draw: 1, pending: 2, finished: 3 }

  belongs_to :product
  belongs_to :winner, class_name: 'User', optional: true
  belongs_to :winning_ticket, class_name: 'RaffleTicket', optional: true

  has_many :raffle_tickets

  validates :draw_date, presence: true, on: :set_draw_date
  validates :lotto_numbers, presence: true, on: :draw
  validates :lotto_numbers_combination, presence: true, on: :draw
  validates :max_ticket_number, numericality: { greater_than: 0 }
  validates :title, presence: true
  validates :winner, presence: true, on: :draw
  validates :winning_ticket, presence: true, on: :draw

  delegate :price_cents, to: :product
end
