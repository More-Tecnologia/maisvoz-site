# frozen_string_lditeral: true

class SystemConfiguration < ApplicationRecord
  validates :company_name, presence: true

  scope :active, -> { where(active: true) }

  class << self
    def active_config
      return unless table_exists?

      active.first
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def add_expense_amount(amount)
      return unless table_exists?

      active_config.increment(:expense_cent_amount, amount.to_f * 1e8).save!
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def company_name
      return ENV['COMPANY_NAME'] unless table_exists?

      active_config.try(:company_name).presence
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def expense_cent_amount
      return unless table_exists?

      active_config.expense_cent_amount / 1e8.to_f if active_config.expense_cent_amount
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def reputation?
      return ActiveModel::Type::Boolean.new.cast(ENV['REPUTATION']) unless table_exists?

      active_config.reputation
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def taxable_fee
      return (active_config.taxable_fee / 100) if table_exists? && active_config.taxable_fee.present?

      ENV['SYSTEM_FEE']
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def withdrawal_fee
      return active_config.withdrawal_fee if table_exists? && active_config.withdrawal_fee.present?

      ENV['WITHDRAWAL_FEE']
    rescue ActiveRecord::NoDatabaseError
      false
    end
  end
end
