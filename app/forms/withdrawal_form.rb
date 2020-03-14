class WithdrawalForm < Form

  attribute :amount
  attribute :user, User
  attribute :fiscal_document_link
  attribute :fiscal_document_photo

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: ENV['WITHDRAWAL_MINIMUM_VALUE'].to_f }

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
    ENV['WITHDRAWAL_FEE'].to_d
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
    amount_cents * (ENV['WITHDRAWAL_FEE'].to_f / 100)
  end

  private

  def user_has_balance
    return if amount_cents <= user.available_balance
    errors.add(:base, I18n.t('defaults.errors.no_funds'))
  end

  def fiscal_document_presence
    return if fiscal_document_link.present? || fiscal_document_photo.present?
    errors.add(:fiscal_document_link, :blank)
  end

end
