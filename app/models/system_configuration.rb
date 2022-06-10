# frozen_string_lditeral: true

class SystemConfiguration < ApplicationRecord
  has_attachment :banner_email, accept: %i[jpg png svg]
  has_attachment :external_logo, accept: %i[jpg png svg]
  has_attachment :logo, accept: %i[jpg png svg]
  has_attachment :favico, accept: %i[ico]

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

    def banner_email
      return unless table_exists?

      active_config&.banner_email&.fullpath.presence || 'banners/white-label-email.png'
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def base_host
      return ENV['BASE_HOST'] unless table_exists?

      active_config.base_host
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def company_name
      return ENV['COMPANY_NAME'] unless table_exists?

      active_config.try(:company_name).presence
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def external_logo
      return unless table_exists?

      active_config&.external_logo&.fullpath.presence || 'white-label-logo.png'
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def favico
      return unless table_exists?

      active_config&.favico&.fullpath.presence || 'favicon-whitelabel.ico'
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def expense_cent_amount
      return unless table_exists?

      active_config.expense_cent_amount / 1e8.to_f if active_config.expense_cent_amount
    rescue ActiveRecord::NoDatabaseError
      false
    end

    def logo
      return unless table_exists?

      active_config&.logo&.fullpath.presence || 'logo-white-white-label.png'
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
