# frozen_string_literal: true

class RaffleTicket < ApplicationRecord
  enum status: { available: 0, reserved: 1, acquired: 2 }

  belongs_to :order_item, optional: true
  belongs_to :raffle
  belongs_to :user, optional: true

  has_one :awarded_raffle, class_name: 'Raffle', foreign_key: :winning_ticket_id

  validates :number, presence: true, numericality: { greater_than: 0 },
            uniqueness: { scope: :raffle, message: I18n.t(:ticket_already_taken) }
  validates :order_item, presence: true, if: :owned?
  validates :raffle, presence: true
  validates :user, presence: true, if: :owned?
  validates_associated :raffle

  scope :owned, -> { where.not(status: :available, user: nil, order_item: nil) }

  private

  def owned?
    reserved? || acquired?
  end
end
