# frozen_string_lditeral: true

class SystemConfiguration < ApplicationRecord
  validates :company_name, presence: true

  scope :active, -> { where(active: true) }

  def self.active_config
    return unless table_exists?

    active.first
  end

  def self.company_name
    return ENV['COMPANY_NAME'] unless table_exists?

    active_config.try(:company_name).presence
  end

  def self.taxable_fee
    return (active_config.taxable_fee / 100) if table_exists? && active_config.taxable_fee.present?

    ENV['SYSTEM_FEE']
  end

  def self.withdrawal_fee
    return active_config.withdrawal_fee if table_exists? && active_config.withdrawal_fee.present?

    ENV['WITHDRAWAL_FEE']
  end

  def self.add_expense_amount(amount)
    return unless table_exists?

    active_config.increment(:expense_cent_amount, amount.to_f * 1e8).save!
  end

  def self.expense_cent_amount
    return unless table_exists?

    active_config.expense_cent_amount / 1e8.to_f if active_config.expense_cent_amount
  end
end
