module BankCodes

  BANK_CODES = [
    ['BANCO DO BRASIL S.A.', '001'],
    ['BANCO ITAÚ S.A.', '341'],
    ['CAIXA ECONOMICA FEDERAL', '104'],
    ['BANCO BRADESCO S.A.', '237'],
    ['BANCO SANTANDER S.A.', '033']
  ].freeze

  def bank_codes
    BANK_CODES
  end

  def bank_account_types
    [
      'Conta Corrente',
      'Conta Poupança'
    ]
  end

  def self.find_by_code(code)
    bank = BANK_CODES.select do |name, bank_code|
      code == bank_code
    end

    bank[0]&.first
  end

end
