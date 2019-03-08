class BankAccountForm < Form

  include BankCodes

  attribute :account_number, Integer
  attribute :account_digit, Integer
  attribute :agency_number, Integer
  attribute :agency_digit, Integer
  attribute :bank_code
  attribute :bank_account_type
  attribute :user

  validates :account_number, :agency_number, :bank_code, :bank_account_type, presence: true

  def bank_account
    return account_number if account_digit.blank?

    "#{account_number}-#{account_digit}"
  end

  def bank_agency
    return agency_number if agency_digit.blank?

    "#{agency_number}-#{agency_digit}"
  end

end
