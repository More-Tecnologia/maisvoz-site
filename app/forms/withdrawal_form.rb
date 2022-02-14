class WithdrawalForm < Form
  attribute :amount
  attribute :user, User
  attribute :fiscal_document_link
  attribute :fiscal_document_photo
  attribute :wallet_address
  attribute :pix_wallet
  attribute :payment_method

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: proc { |f| f.withdrawal_minimum },
                                     less_than_or_equal_to: proc { |f| f.withdrawal_maximum } }
  validates :payment_method, presence: true
  validates :wallet_address, presence: true

  validate :user_has_balance
  validate :fiscal_document_presence, if: -> { user.pj? }

  def amount=(value)
    @amount = value.to_s.gsub('.','').gsub(',','.').to_f if value
  end

  def amount_cents
    amount
  end

  def net_amount_cents
    amount_cents - fee_cents
  end

  def fee
    amount ? amount.to_d - fee_cents : 0
  end

  def total
    amount ? amount.to_d - fee : 0
  end

  def withdrawal_fee
    SystemConfiguration.withdrawal_fee.to_d
  end

  def irpf
    ENV['IRPF'].to_f if ENV['IRPF'].to_f > 0
  end

  def irpf_cents
    irpf ? irpf * amount_cents / 100.0 : 0
  end

  def inss
    ENV['INSS'].to_f if ENV['INSS'].to_f > 0
  end

  def inss_cents
    inss ? inss * amount_cents / 100.0 : 0
  end

  def fee_cents
    amount_cents * (withdrawal_fee.to_f / 100)
  end

  def withdrawal_minimum
    @withdrawal_minimum ||= ENV['WITHDRAWAL_MINIMUM_VALUE'].to_f
  end

  def withdrawal_maximum
    user.available_balance
  end

  def contracts_amount
    @contracts_amount ||= user.bonus_contracts.active.sum(&:cent_amount)
  end

  private

  def user_has_balance
    return unless amount_cents > withdrawal_maximum

    errors.add(:base, I18n.t('defaults.errors.no_funds'))
  end

  def fiscal_document_presence
    return if fiscal_document_link.present? || fiscal_document_photo.present?

    errors.add(:fiscal_document_link, :blank)
  end
end
