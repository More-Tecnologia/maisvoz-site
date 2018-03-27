class BankAccountForm < Form

  BANK_CODES = [
    ['BANCO DO BRASIL S.A.', '001'],
    ['BANCO ITAÚ S.A.', '341'],
    ['CAIXA ECONOMICA FEDERAL', '104'],
    ['BANCO BRADESCO S.A.', '237']
  ].freeze

  attribute :account_number, Integer
  attribute :account_digit, Integer
  attribute :agency_number, Integer
  attribute :agency_digit, Integer
  attribute :bank_code
  attribute :user

  validates :account_number, :agency_number, :bank_code, presence: true

  def bank_codes
    BANK_CODES
  end

  def bank_account
    return account_number if account_digit.blank?
    "#{account_number}-#{account_digit}"
  end

  def bank_agency
    return agency_number if agency_digit.blank?
    "#{agency_number}-#{agency_digit}"
  end

end
