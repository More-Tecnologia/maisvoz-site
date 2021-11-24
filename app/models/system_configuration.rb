# frozen_string_literal: true

class SystemConfiguration < ApplicationRecord
  validates :company_name, presence: true

  scope :active, -> { where(active: true) }

  def self.active_config
    active.first
  end

  def self.company_name
    active_config.company_name
  end

  def self.taxable_fee
    active_config.taxable_fee
  end

  def self.withdrawal_fee
    active_config.withdrawal_fee
  end
end
