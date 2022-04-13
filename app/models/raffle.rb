# frozen_string_literal: true

class Raffle < ApplicationRecord
  include Hashid::Rails

  has_attachment :thumb, accept: %i[jpg png]

  enum kind: { automatic: 0, manual: 1, flex: 2 }
  enum status: { started: 0, awaiting_draw_date: 1, awaiting_draw: 2,
                 pending: 3, finished: 4 }

  belongs_to :product
  belongs_to :winner, class_name: 'User', optional: true
  belongs_to :winning_ticket, class_name: 'RaffleTicket', optional: true

  has_many :raffle_tickets, dependent: :destroy
  has_many :light_raffle_tickets,
    -> { select(:number, :status, :raffle_id) }, class_name: 'RaffleTicket'

  validates :draw_date, presence: true, if: :awaiting_draw?
  validates :lotto_numbers, presence: true, if: :drawn?
  validates :lotto_numbers_combination, presence: true, if: :drawn?
  validates :max_ticket_number, numericality: { greater_than: 0 }
  validates :product, presence: true
  validates :raffle_tickets, length: { maximum: :max_ticket_number }
  validates :title, presence: true
  validates :winner, presence: true, if: :drawn?
  validates :winning_ticket, presence: true, if: :drawn?

  delegate :active, :description, :price, :price_cents, :short_description,
           to: :product, allow_nil: true

  def path
    thumb.try(:fullpath)
  end

  private

  def drawn?
    pending? || finished?
  end
end
