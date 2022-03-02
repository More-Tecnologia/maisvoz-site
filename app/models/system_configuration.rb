# frozen_string_literal: true

class SystemConfiguration < ApplicationRecord
  validates :company_name, presence: true

  scope :active, -> { where(active: true) }

  def self.active_config
    active.first
  end

  def self.company_name
    active_config.try(:company_name).presence || ENV['COMPANY_NAME']
  end

  def self.taxable_fee
    return (active_config.taxable_fee / 100) if active_config.try(:taxable_fee)

    ENV['SYSTEM_FEE']
  end

  def self.withdrawal_fee
    active_config.try(:withdrawal_fee).presence || ENV['WITHDRAWAL_FEE']
  end

  def self.add_expense_amount(amount)
    active_config.increment(:expense_cent_amount, amount.to_f * 1e8).save!
  end

  def self.expense_cent_amount
    active_config.expense_cent_amount / 1e8.to_f if active_config.expense_cent_amount
  end
end
